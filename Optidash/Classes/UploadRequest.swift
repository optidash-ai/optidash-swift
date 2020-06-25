//
//  UploadRequest.swift
//  Optidash
//
//  Created by Dawid Płatek on 18/11/2019.
//  Copyright © 2020 Optidash UG. All rights reserved.
//

import Foundation
#if os(iOS)
import MobileCoreServices
#elseif os(macOS)
import CoreServices
#endif

class UploadRequest: BaseRequest {
    var key: String
    var type: RequestType
    var parameters: [String : Any] = [:]
    var isBinary: Bool = false
    let fileUrl: URL

    private let boundary: String

    private let fileManager = FileManager.default

    var contentType: String {
        return "multipart/form-data; boundary=\(boundary)"
    }

    init(key: String, fileUrl: URL) {
        self.type = RequestType.upload
        self.key = key
        self.fileUrl = fileUrl
        self.boundary = BoundaryGenerator.randomBoundary()
    }

    func data() throws -> Data {
        var data = Data()

        if isBinary {
            parameters["response"] = ["mode": "binary"]
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            data.append(initialBoundaryData())
            data.append(Data("Content-Disposition: form-data; name=\"data\"\(EncodingCharacters.crlf)\(EncodingCharacters.crlf)".utf8))
            data.append(jsonData)
            data.append(Data(EncodingCharacters.crlf.utf8))
        }

        let filename = fileUrl.lastPathComponent

        let bodyContentLength: UInt64

        do {
            guard let fileSize = try fileManager.attributesOfItem(atPath: fileUrl.path)[.size] as? NSNumber else {
                throw OptidashError.cannotDetectFileSize
            }

            bodyContentLength = fileSize.uint64Value
        } catch {
            throw OptidashError.cannotDetectFileSize
        }

        guard let stream = InputStream(url: fileUrl) else {
            throw OptidashError.cannotCreateStreamFromFile
        }

        stream.open()
        defer { stream.close() }

        var encodedFileData = Data()

        let streamBufferSize = 1024

        while stream.hasBytesAvailable {
            var buffer = [UInt8](repeating: 0, count: streamBufferSize)
            let bytesRead = stream.read(&buffer, maxLength: streamBufferSize)

            if let _ = stream.streamError {
                throw OptidashError.cannotReadStreamFromFile
            }

            if bytesRead > 0 {
                encodedFileData.append(buffer, count: bytesRead)
            } else {
                break
            }
        }

        let mimeType = mimeTypeForPath(fileUrl.path)

        data.append(encapsulatedBoundaryData())
        data.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\(EncodingCharacters.crlf)".utf8))
        data.append(Data("Content-Type: \(mimeType)\(EncodingCharacters.crlf)\(EncodingCharacters.crlf)".utf8))
        data.append(encodedFileData)
        data.append(finalBoundaryData())

        return data
    }

    private func mimeTypeForPath(_ path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }

    private func initialBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .initial, boundary: boundary)
    }

    private func encapsulatedBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .encapsulated, boundary: boundary)
    }

    private func finalBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .final, boundary: boundary)
    }
}
