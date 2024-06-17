
import Foundation
import UIKit
import CryptoKit

struct FileOperation {
    //    func saveFile(with name: String) throws {
    //        let fileManager = FileManager.default
    //        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    //        let fileURL = documentDirectory.appendingPathComponent(name)
    //        let image = #imageLiteral(resourceName: "rw-logo")
    //        guard let imageData = image.jpegData(compressionQuality: 0.5) else { throw URLError(.cannotDecodeContentData) }
    //        try imageData.write(to: fileURL)
    //    }
    
    static func saveFile(url: URL,
                         data: Data) throws {
        try data.write(to: url, options: Data.WritingOptions.atomic)
    }
    
    
    static func saveFileNoException(url: URL,
                                    data: Data) throws {
        do {
            try data.write(to: url, options: Data.WritingOptions.atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static var fileManager: FileManager {
        FileManager.default
    }
    static var documentDirectory: URL? {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return documentDirectory
        } catch {
            print(error.localizedDescription)
            
        }
        return nil
    }
    static func getLocalURL(fileName: String) throws -> URL {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        //        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        return fileURL
    }
    
    static func fileExists(at path: String) -> Bool {
        let isExisted = FileManager.default.fileExists(atPath: path)
        return isExisted
    }
    
    static func loadImage(at path: String) -> UIImage? {
        //        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //        let documentPath = paths[0]
        //        let imagePath = documentPath.appending(path)
        
        let imagePath = path
        guard FileOperation.fileExists(at: imagePath) else {
            return nil
        }
        
        guard let image = UIImage(contentsOfFile: imagePath) else {
            return nil
        }
        return image
    }
}

extension String {
    @available(iOS 13.0, *)
    var sha256Hash: String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        print(hashed.description) //8660da3fe5f1fbf8e150e5afd57cb2bc074b95e66b993ac4e612d88f6bfc1c08
        //        print(hashString)
        return hashString
    }
}



extension String {
    
    /// Returns a new string made by appending to the receiver a filesystem path component.
    ///
    /// - parameter pathComponent: The path component to be appended to the receiver.
    ///
    /// - returns: A new `String` made by appending `pathComponent` to the receiver, preceded if necessary by a path separator.
    
    public func stringByAppendingPathComponent(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    /// Return a filesystem path composed of the specified components.
    ///
    /// - parameter pathComponents: list of filesystem path components.
    ///
    /// - returns: A `String` consisting of path components with delimiters between them.
    
    public static func fromPathComponents(pathComponents: String...) -> String {
        return pathComponents.reduce("", { $0.stringByAppendingPathComponent(pathComponent: $1) })
    }
}

// MARK: - URLFileAttribute
public struct URLFileAttribute {
    private(set) var fileSize: UInt? = nil
    private(set) var creationDate: Date? = nil
    private(set) var modificationDate: Date? = nil
    
    init(url: URL) {
        let path = url.path
        guard let dictionary: [FileAttributeKey: Any] = try? FileManager.default
            .attributesOfItem(atPath: path) else {
            return
        }
        
        if dictionary.keys.contains(FileAttributeKey.size),
           let value = dictionary[FileAttributeKey.size] as? UInt {
            self.fileSize = value
        }
        
        if dictionary.keys.contains(FileAttributeKey.creationDate),
           let value = dictionary[FileAttributeKey.creationDate] as? Date {
            self.creationDate = value
        }
        
        if dictionary.keys.contains(FileAttributeKey.modificationDate),
           let value = dictionary[FileAttributeKey.modificationDate] as? Date {
            self.modificationDate = value
        }
    }
}

extension URL {
    public var fileAttribute: URLFileAttribute {
        URLFileAttribute(url: self)
    }
    public func directoryContents() -> [URL] {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil)
            return directoryContents
        } catch let error {
            print("Error: \(error)")
            return []
        }
    }
    
    public func folderSize() -> UInt {
        let contents = self.directoryContents()
        var totalSize: UInt = 0
        contents.forEach { url in
            let size = url.fileSize()
            totalSize += size
        }
        return totalSize
    }
    
    public func fileSize() -> UInt {
        let attributes = URLFileAttribute(url: self)
        return attributes.fileSize ?? 0
    }
    
    public func fileCreationDate() -> Date {
        let attributes = URLFileAttribute(url: self)
        return attributes.creationDate ?? Date()
    }
    
    public func fileModificationDate() -> Date {
        let attributes = URLFileAttribute(url: self)
        return attributes.modificationDate ?? Date()
    }
}



//   private func updateLocalUrl() throws  {
//       var fileName = resourceRemoteURL.absoluteString.sha256Hash
//       if let name = resourceName {
//           fileName = name
//       } else {
//           resourceName = fileName
//       }
//       resourceLocalURL = try FileOperation.getLocalURL(fileName: fileName)
//   }
//   
//   class func localURLFor(remoteURL: String) throws -> String {
//       var fileName = remoteURL.sha256Hash
//       let localURL = try FileOperation.getLocalURL(fileName: fileName).absoluteString
//       return localURL
//   }
