//
//  BaseRequest.swift
//  Optidash
//
//  Created by Dawid Płatek on 18/11/2019.
//  Copyright © 2020 Optidash UG. All rights reserved.
//

import Foundation

enum RequestType: String {
    case fetch = "fetch"
    case upload = "upload"
}

protocol BaseRequest {
    var baseUrl: URL { get }
    var key: String { get }
    var type: RequestType { get }
    var headers: [String: String?] { get }
    var parameters: [String: Any] { get set }
    var isBinary: Bool { get set }
    var contentType: String { get }
    var urlRequest: URLRequest { get }
    func data() throws -> Data
}

extension BaseRequest {
    var baseUrl: URL {
        return URL(string: "https://api.optidash.ai/1.0")!
    }

    var headers: [String: String?] {
        var headers: [String: String?] = [:]
        headers["Authorization"] = "Bearer \(key)"

        if isBinary {
            headers["x-optidash-binary"] = "true"
        }

        return headers
    }

    mutating func setBinary(_ binary: Bool) -> BaseRequest {
        isBinary = binary

        return self
    }

    var urlRequest: URLRequest {
        let url = URL(string: "\(baseUrl.absoluteString)/\(type.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        headers.forEach { (key: String, value: String?) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        return request
    }
}
