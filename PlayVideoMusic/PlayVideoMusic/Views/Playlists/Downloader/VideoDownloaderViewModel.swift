
import Foundation
import SwiftUI
import CoreData
import Combine

@MainActor
class VideoDownloaderViewModel: NSObject, ObservableObject {
    // MARK: Object Selected Play Video
    var item: Item? {
        didSet {
            loadInfoVideo(videoId: item?.idVideo.videoID ?? "")
        }
    }
    @Published var miniPlayerModel: MiniPlayerModel?
    
    // MARK: MiniPlayer properties
    @Published var isShowPlayer = false
    @Published var isHaveUrl = false
    // MARK: Gesture offset
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var height: CGFloat = 0
    @Published var isNormalPlayer = true
    @Published var thumbImage: UIImage? = nil
    
    
    var videoCoreData: NSManagedObjectContext?
    var autoSaveCoreData: Bool
    var audioOnly: Bool
    var maximumQuality: Bool
     init(autoSaveCoreData: Bool = true,
          audioOnly: Bool = false,
        maximumQuality: Bool = true) {
         self.autoSaveCoreData = autoSaveCoreData
         self.audioOnly = audioOnly
         self.maximumQuality = maximumQuality
         super.init()
    }
    
    // MARK: Handle Video
    private let dataSearchVideoService = PlayVideoUrlService()
    
    var subscriptions: Set<AnyCancellable> = []
  
    var fileToDownload: String {
        return selectedQuality?.url ?? ""
    }
    var localFile: String {
        return [url.sha256Hash, format ?? ""].joined(separator: ".")
    }
    var selectedQuality: Quality? {
        var selections = miniPlayerModel?.qualities
        
        if audioOnly {
            selections = miniPlayerModel?.qualities.filter {
                $0.qualityInfo.type == 3
            }
        } else  {
            selections = miniPlayerModel?.qualities.filter {
                $0.qualityInfo.type != 3
            }
        }
        
        if selections?.isEmpty == true {
            selections = miniPlayerModel?.qualities
        }
        
        if maximumQuality {
            return selections?.first
        } else {
            return selections?.last
        }
        
    }
    
    //For CoreData
    var id: String {
        return miniPlayerModel?.videoId ?? ""
    }
    var localURL: String? {
        do {
            let local = try FileOperation.getLocalURL(fileName: localFile)
            return local.absoluteString
        } catch {
            print(error)
        }
        
        return nil
    }
    var url: String {
        return "https://www.youtube.com/watch?v=\(miniPlayerModel?.videoId ?? "")"
    }
    var title: String {
        return miniPlayerModel?.metaInfo.title ?? ""
    }
    var quality: String? {
        return selectedQuality?.qualityInfo.qualityLabel
    }
    var format: String? {
        return (selectedQuality?.qualityInfo.format ?? "").lowercased()
    }
    //
    
    
    
    
    
    func loadInfoVideo(videoId: String) {
        dataSearchVideoService.fetchInfomationVideo(with: videoId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                print("ANHND47 status: \(status)")
            }, receiveValue: { [weak self] miniPlayer in
                guard let self = self else {
                    return
                }
                print("ANHND47 miniPlayer: \(miniPlayer)")
                self.isHaveUrl = true
                self.miniPlayerModel = miniPlayer
                
//                Task { @MainActor in
//                    await self.downloadInMemory()
//                }
               
//               downloadInBackground()
                
                downloadFileManager()
            })
            .store(in: &subscriptions)
    }
    
    
    
    @Published private(set) var isBusy = false
    @Published private(set) var error: String? = nil
    @Published private(set) var percentage: Int? = nil
    @Published private(set) var fileName: String? = nil
    @Published private(set) var downloadedSize: UInt64? = nil
    @Published private(set) var fileLocalURL: URL? = nil
    
    func downloadFileManager() {
        // task.pause is not implemented yet
        if let url = URL(string: fileToDownload) {
            print("Downloading: \(fileToDownload)")
            let task = FileDownloadManager.shared.download(from: url)
            task.delegate = self
            task.resume()
        }
    }
    
    // https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
    func downloadInMemory() async {
        self.isBusy = true
        self.error = nil
        self.percentage = 0
        self.fileName = nil
        self.downloadedSize = nil

        defer {
            self.isBusy = false
        }

        do {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["User-Agent": ""]
            // config.waitsForConnectivity = false
            // config.allowsCellularAccess = true
            // config.allowsConstrainedNetworkAccess = true
            let urlSession = URLSession(configuration: config)
            print("Downloading: \(fileToDownload)")
            let (data, response) = try await urlSession.data(from: URL(string: fileToDownload)!)
            guard let httpResponse = response as? HTTPURLResponse else {
                self.error = "No HTTP Result"
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                self.error =  "Http Result: \(httpResponse.statusCode)"
                return
            }

            self.error = nil
            self.percentage = 100
            self.fileName = nil
            self.downloadedSize = UInt64(data.count)
            
            
            do {
                let localURL = try FileOperation.getLocalURL(fileName: localFile)
                try FileOperation.saveFile(url: localURL, data: data)
                print("Downloaded file: \(localURL.absoluteString)")
                print("From remote: \(fileToDownload)")
                Task { @MainActor in
                    fileLocalURL = localURL
                }
               
                if autoSaveCoreData {
                    saveCoreData()
                }
            } catch {
                print(error)
                Task { @MainActor in
                    fileLocalURL = nil
                }
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
    

    // https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "Video.Download.Session.Background")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        config.httpAdditionalHeaders = ["User-Agent": ""]
        // config.waitsForConnectivity = false
        // config.allowsCellularAccess = true
        // config.allowsConstrainedNetworkAccess = true
        
//        let config = URLSessionConfiguration.default
//        config.httpAdditionalHeaders = ["User-Agent": ""]
//        // config.waitsForConnectivity = false
//        // config.allowsCellularAccess = true
//        // config.allowsConstrainedNetworkAccess = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    @Published private var downloadTask: URLSessionDownloadTask? = nil
    func downloadInBackground() {
        print("Downloading: \(fileToDownload)")
        self.isBusy = true
        self.error = nil
        self.percentage = 0
        self.fileName = nil
        self.downloadedSize = nil

        let downloadTask = urlSession.downloadTask(with: URL(string: fileToDownload)!)
        // downloadTask.earliestBeginDate = Date().addingTimeInterval(60 * 60)
        // downloadTask.countOfBytesClientExpectsToSend = 200
        // downloadTask.countOfBytesClientExpectsToReceive = 500 * 1024
        downloadTask.priority = .greatestFiniteMagnitude
        downloadTask.resume()
        self.downloadTask = downloadTask
    }

    // https://developer.apple.com/documentation/foundation/url_loading_system/pausing_and_resuming_downloads
    @Published private var resumeData: Data? = nil
    var canPauseDownload: Bool {
        self.downloadTask != nil && self.resumeData == nil
    }
    func pauseDownload() {
        guard let downloadTask = self.downloadTask else {
            return
        }
        downloadTask.cancel { resumeDataOrNil in
            guard let resumeData = resumeDataOrNil else {
                // download can't be resumed; remove from UI if necessary
                return
            }
            Task { @MainActor in self.resumeData = resumeData }
        }
    }

    // https://developer.apple.com/documentation/foundation/url_loading_system/pausing_and_resuming_downloads
    var canResumeDownload: Bool {
        self.resumeData != nil
    }
    func resumeDownload() {
        guard let resumeData = self.resumeData else {
            return
        }
        let downloadTask = urlSession.downloadTask(withResumeData: resumeData)
        downloadTask.resume()
        self.error = nil
        self.downloadTask = downloadTask
        self.resumeData = nil
    }
}

extension VideoDownloaderViewModel: URLSessionDownloadDelegate {
    // https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_from_websites
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        if downloadTask != self.downloadTask {
            return
        }

        let percentage = Int(totalBytesWritten * 100 / totalBytesExpectedToWrite)

        Task { @MainActor in self.percentage = percentage }
    }

    // https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_from_websites
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if downloadTask != self.downloadTask {
            return
        }
        
        defer {
            Task { @MainActor in self.isBusy = false }
        }
        
        guard let httpResponse = downloadTask.response as? HTTPURLResponse else {
            Task { @MainActor in self.error = "No HTTP Result" }
            return
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            Task { @MainActor in self.error = "Http Result: \(httpResponse.statusCode)" }
            return
        }
        
        let fileName = location.path
        let attributes = try? FileManager.default.attributesOfItem(atPath: fileName)
        let fileSize = attributes?[.size] as? UInt64
        
        let local = localFile
        do {
            let data = try Data(contentsOf: location)
            let localURL = try FileOperation.getLocalURL(fileName: local)
            try FileOperation.saveFile(url: localURL, data: data)
            print("Downloaded file: \(localURL.absoluteString ?? "")")
            print("From remote: \(fileToDownload)")
            Task { @MainActor in
                fileLocalURL = localURL
            }
           
            if autoSaveCoreData {
                saveCoreData()
            }
        } catch {
            print(error)
            Task { @MainActor in
                fileLocalURL = nil
            }
        }
        
        
        Task { @MainActor in
            self.error = nil
            self.percentage = 100
            self.fileName = fileName
            self.downloadedSize = fileSize
            self.downloadTask = nil
        }
    }

    // https://developer.apple.com/documentation/foundation/url_loading_system/pausing_and_resuming_downloads
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            return
        }
        Task { @MainActor in self.error = error.localizedDescription }

        let userInfo = (error as NSError).userInfo
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            Task { @MainActor in self.resumeData = resumeData }
        } else {
            Task { @MainActor in
                self.fileLocalURL = nil
                self.isBusy = false
                self.downloadTask = nil
            }
        }
    }
}

extension VideoDownloaderViewModel {
    func saveCoreData() {
        guard let videoCoreData = videoCoreData else { return }
        let sample = Video(context: videoCoreData)
        sample.id = id
        sample.title = title
        sample.format = format
        sample.quality = quality
        sample.url = url
        sample.localURL = localFile
        do {
            try videoCoreData.save()
        } catch {
            print(error)
        }
    }
}


extension VideoDownloaderViewModel: MultiPartDownloadTaskDelegate {
    /// Called when the download progress changed
    func didProgress(
        _ downloadTask: MultiPartsDownloadTask
    ) {
//        if downloadTask != self.downloadTask {
//            return
//        }
//
        let percentage = downloadTask.progress

        Task { @MainActor in self.percentage = Int(percentage) }
        
    }
    
    /// Called when the download finished succesfully
    func didFinish(
        _ downloadTask: MultiPartsDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        
//        if downloadTask != self.downloadTask {
//            return
//        }
//        
        defer {
            Task { @MainActor in self.isBusy = false }
        }
//        
//        guard let httpResponse = downloadTask.response as? HTTPURLResponse else {
//            Task { @MainActor in self.error = "No HTTP Result" }
//            return
//        }
//        guard (200...299).contains(httpResponse.statusCode) else {
//            Task { @MainActor in self.error = "Http Result: \(httpResponse.statusCode)" }
//            return
//        }
//        
        let fileName = location.path
        let attributes = try? FileManager.default.attributesOfItem(atPath: fileName)
        let fileSize = attributes?[.size] as? UInt64
        
        let local = localFile
        do {
            let data = try Data(contentsOf: location)
            let localURL = try FileOperation.getLocalURL(fileName: local)
            try FileOperation.saveFile(url: localURL, data: data)
            print("Downloaded file: \(localURL.absoluteString ?? "")")
            print("From remote: \(fileToDownload)")
            
            Task { @MainActor in
                self.error = nil
                self.percentage = 100
                self.fileName = fileName
                self.downloadedSize = fileSize
                self.fileLocalURL = localURL
                self.downloadTask = nil
            }
           
            if autoSaveCoreData {
                saveCoreData()
            }
        } catch {
            print(error)
            Task { @MainActor in
                self.fileLocalURL = nil
                self.isBusy = false
                self.downloadTask = nil
            }
        }
        
    }
    
    /// Called when the download failed
    func didFail(_ downloadTask: MultiPartsDownloadTask, error: Error) {
        Task { @MainActor in self.error = error.localizedDescription }

        let userInfo = (error as NSError).userInfo
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            Task { @MainActor in self.resumeData = resumeData }
        } else {
            Task { @MainActor in
                self.fileLocalURL = nil
                self.isBusy = false
                self.downloadTask = nil
            }
        }
    }
}
