//
//  OptidashClient.swift
//  Optidash
//
//  Created by Dawid Płatek on 12/11/2019.
//  Copyright © 2020 Optidash UG. All rights reserved.
//

import Foundation

class OptidashClient {
    let key: String
    var request: BaseRequest?

    private let sessionConfiguration = URLSessionConfiguration.default

    private lazy var session = {
        return URLSession(configuration: self.sessionConfiguration)
    }()

    init(key: String) {
        self.key = key
    }

    func fetch(url: String) -> OptidashClient {
        request = FetchRequest(key: key, url: url)

        return self
    }

    func upload(fileUrl: URL) -> OptidashClient {
        request = UploadRequest(key: key, fileUrl: fileUrl)

        return self
    }

    func proxy(url: URL) -> OptidashClient {
        sessionConfiguration.connectionProxyDictionary = [
            kCFNetworkProxiesHTTPEnable as AnyHashable: true,
            kCFNetworkProxiesHTTPProxy as AnyHashable: url.absoluteString
        ]

        return self
    }

    func toJson(completionHandler: @escaping (Result<Data, Error>) -> Void) throws {
        request?.isBinary = false

        guard let urlRequest = request?.urlRequest else {
            throw OptidashError.unknownError
        }

        let requestData = try request?.data()

        let task = session.uploadTask(with: urlRequest, from: requestData) { (responseData, _, error) in
            if let responseData = responseData {
                completionHandler(.success(responseData))
                return
            }

            if let error = error {
                completionHandler(.failure(error))
                return
            }

            completionHandler(.failure(OptidashError.unknownError))
        }

        task.resume()
    }

    func toImageData(completionHandler: @escaping (Result<Data, Error>) -> Void) throws {
        request?.isBinary = true

        guard let urlRequest = request?.urlRequest else {
            throw OptidashError.unknownError
        }

        let requestData = try request?.data()

        let task = session.uploadTask(with: urlRequest, from: requestData) { (responseData, response, error) in
            if let responseData = responseData {
                completionHandler(.success(responseData))
                return
            }

            if let error = error {
                completionHandler(.failure(error))
                return
            }

            completionHandler(.failure(OptidashError.unknownError))
        }

        task.resume()
    }

    func adjust(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["adjust"] = parameters

        return self
    }

    func auto(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["auto"] = parameters

        return self
    }

    func border(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["border"] = parameters

        return self
    }

    func crop(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["crop"] = parameters

        return self
    }

    func mask(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["mask"] = parameters

        return self
    }

    func output(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["output"] = parameters

        return self
    }

    func padding(parameters: [String: Any]) -> OptidashClient {
        request?.parameters["padding"] = parameters

        return self
    }

    func resize(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["resize"] = parameters

        return self
    }

    func response(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["response"] = parameters

        return self
    }

    func scale(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["scale"] = parameters

        return self
    }

    func store(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["store"] = parameters

        return self
    }

    func filter(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["filter"] = parameters

        return self
    }

    func watermark(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["watermark"] = parameters

        return self
    }

    func webhook(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["webhook"] = parameters

        return self
    }

    func cdn(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["cdn"] = parameters

        return self
    }

    func flip(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["flip"] = parameters

        return self
    }

    func optimize(_ parameters: [String: Any]) -> OptidashClient {
        request?.parameters["optimize"] = parameters

        return self
    }
}
