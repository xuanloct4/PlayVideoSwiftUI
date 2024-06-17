import Foundation

/// Holds a weak reverence
class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}

enum DownloadError: Error {
    case missingData
}

/// Represents the download of one part of the file
fileprivate class DownloadTask {
    /// The position (included) of the first byte
    let startOffset: Int64
    /// The position (not included) of the last byte
    let endOffset: Int64
    /// The byte length of the part
    var size: Int64 { return endOffset - startOffset }
    /// The number of bytes currently written
    var bytesWritten: Int64 = 0
    /// The URL task corresponding to the download
    let request: URLSessionDownloadTask
    /// The disk location of the saved file
    var didWriteTo: URL?
    
    init(for url: URL, from start: Int64, to end: Int64, in session: URLSession) {
        startOffset = start
        endOffset = end
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields?["Range"] = "bytes=\(start)-\(end - 1)"
        
        self.request = session.downloadTask(with: request)
    }
}

/// Represents the download of a file (that is done in multi parts)
class MultiPartsDownloadTask {
    
    weak var delegate: MultiPartDownloadTaskDelegate?
    /// the current progress, from 0 to 1
    var progress: CGFloat {
        var total: Int64 = 0
        var written: Int64 = 0
        parts.forEach({ part in
            total += part.size
            written += part.bytesWritten
        })
        guard total > 0 else { return 0 }
        return CGFloat(written) / CGFloat(total)
    }
    
    fileprivate var parts = [DownloadTask]()
    fileprivate var contentLength: Int64?
    fileprivate let url: URL
    private var session: URLSession
    private var isStoped = false
    private var isResumed = false
    /// When the download started
    private var startedAt: Date
    /// An estimate on how long left before the download is over
    var remainingTimeEstimate: CGFloat {
        let progress = self.progress
        guard progress > 0 else { return CGFloat.greatestFiniteMagnitude }
        return CGFloat(Date().timeIntervalSince(startedAt)) / progress * (1 - progress)
    }
    
    fileprivate init(from url: URL, in session: URLSession) {
        self.url = url
        self.session = session
        startedAt = Date()
        
        getRemoteResourceSize { size, error in
            //      guard let self = self else { return }
            guard error == nil else {
                self.isStoped = true
                return
            }
            self.contentLength = size
            self.createDownloadParts()
            
            if self.isResumed {
                self.resume()
            }
        }
    }
    
    /// Start the download
    func resume() {
        guard !isStoped else { return }
        startedAt = Date()
        isResumed = true
        parts.forEach({ $0.request.resume() })
    }
    
    /// Cancels the download
    func cancel() {
        guard !isStoped else { return }
        parts.forEach({ $0.request.cancel() })
    }
    
    /// Fetch the file size of a remote resource
    private func getRemoteResourceSize(completion: @escaping (Int64?, Error?) -> Void) {
        let config = URLSessionConfiguration.default
        //        config.httpMaximumConnectionsPerHost = 50
        let remoteSession = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        
        var headRequest = URLRequest(url: url)
        headRequest.httpMethod = "HEAD"
        remoteSession.dataTask(with: headRequest, completionHandler: { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let expectedContentLength = response?.expectedContentLength else {
                completion(nil, FileCacheError.sizeNotAvailableForRemoteResource)
                return
            }
            completion(expectedContentLength, nil)
        }).resume()
    }
    
    /// Split the download request into multiple request to use more bandwidth
    private func createDownloadParts() {
        guard let size = contentLength else { return }
        
        let numberOfRequests = 20
        for i in 0..<numberOfRequests {
            let start = Int64(ceil(CGFloat(Int64(i) * size) / CGFloat(numberOfRequests)))
            let end = Int64(ceil(CGFloat(Int64(i + 1) * size) / CGFloat(numberOfRequests)))
            parts.append(DownloadTask(for: url, from: start, to: end, in: session))
        }
    }
    
    fileprivate func didFail(_ error: Error) {
        cancel()
        delegate?.didFail(self, error: error)
    }
    
    fileprivate func didFinishOnePart() {
        if parts.filter({ $0.didWriteTo != nil }).count == parts.count {
            mergeFiles()
        }
    }
    
    /// Put together the download files
    private func mergeFiles() {
        let ext = self.url.pathExtension
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(String.random(ofLength: 5))")
            .appendingPathExtension(ext)
        
        do {
            let partLocations = parts.flatMap({ $0.didWriteTo })
            try FileManager.default.merge(files: partLocations, to: destination)
            delegate?.didFinish(self, didFinishDownloadingTo: destination)
            for partLocation in partLocations {
                do {
                    try FileManager.default.removeItem(at: partLocation)
                } catch {
                    print(error)
                }
            }
        } catch {
            delegate?.didFail(self, error: error)
        }
    }
    
    deinit {
        FileDownloadManager.shared.tasks = FileDownloadManager.shared.tasks.filter({
            $0 !== self
        })
    }
}

protocol MultiPartDownloadTaskDelegate: AnyObject {
    /// Called when the download progress changed
    func didProgress(
        _ downloadTask: MultiPartsDownloadTask
    )
    
    /// Called when the download finished succesfully
    func didFinish(
        _ downloadTask: MultiPartsDownloadTask,
        didFinishDownloadingTo location: URL
    )
    
    /// Called when the download failed
    func didFail(_ downloadTask: MultiPartsDownloadTask, error: Error)
}

/// Manage files downloads
class FileDownloadManager: NSObject {
    static let shared = FileDownloadManager()
    private var session: URLSession!
    fileprivate var tasks = [MultiPartsDownloadTask]()
    
    private override init() {
        super.init()
//        let config = URLSessionConfiguration.default
//        config.httpMaximumConnectionsPerHost = 50
        
        let config = URLSessionConfiguration.background(withIdentifier: "Video.Download.Session.Background")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        config.httpAdditionalHeaders = ["User-Agent": ""]
        
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    /// Create a task to download a file
    func download(from url: URL) -> MultiPartsDownloadTask {
        let task = MultiPartsDownloadTask(from: url, in: session)
        tasks.append(task)
        return task
    }
    
    /// Returns the download task that correspond to the URL task
    fileprivate func match(request: URLSessionTask) -> (MultiPartsDownloadTask, DownloadTask)? {
        for wtask in tasks {
            let task = wtask
            let tsks = task.parts
            print(tsks)
            for part in task.parts {
                if part.request == request {
                    return (task, part)
                }
            }
            
        }
        return nil
    }
}

extension FileDownloadManager: URLSessionDownloadDelegate {
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        guard let x = match(request: downloadTask) else { return }
        let multiPart = x.0
        let part = x.1
        
        part.bytesWritten = totalBytesWritten
        multiPart.delegate?.didProgress(multiPart)
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard let x = match(request: downloadTask) else { return }
        let multiPart = x.0
        let part = x.1
        
        let ext = multiPart.url.pathExtension
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(String.random(ofLength: 5))")
            .appendingPathExtension(ext)
        do {
            try FileManager.default.moveItem(at: location, to: destination)
        } catch {
            multiPart.didFail(error)
            return
        }
        
        part.didWriteTo = destination
        multiPart.didFinishOnePart()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error, let multipart = match(request: task)?.0 else { return }
        multipart.didFail(error)
    }
}

extension FileManager {
    /// Merge the files into one (without deleting the files)
    func merge(files: [URL], to destination: URL, chunkSize: Int = 1000000) throws {
        FileManager.default.createFile(atPath: destination.path, contents: nil, attributes: nil)
        let writer = try FileHandle(forWritingTo: destination)
        try files.forEach({ partLocation in
            let reader = try FileHandle(forReadingFrom: partLocation)
            var data = reader.readData(ofLength: chunkSize)
            while data.count > 0 {
                writer.write(data)
                data = reader.readData(ofLength: chunkSize)
            }
            reader.closeFile()
        })
        writer.closeFile()
    }
    
    func createTempDirectory() throws -> String {
        let tempDirectory = (NSTemporaryDirectory() as NSString).appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(atPath: tempDirectory,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
        return tempDirectory
    }
}


enum FileCacheError: Error {
    case sizeNotAvailableForRemoteResource
}

extension String {
    static func random(ofLength: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<ofLength).map{ _ in letters.randomElement()! })
    }
}
