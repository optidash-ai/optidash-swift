//
//  FetchRequest.swift
//  Optidash
//
//  Created by Dawid Płatek on 18/11/2019.
//  Copyright © 2020 Optidash UG. All rights reserved.
//

import Foundation

class FetchRequest: BaseRequest {
    var key: String
    var type: RequestType
    var parameters: [String : Any] = [:]
    var isBinary: Bool = false
    let url: String

    var contentType: String {
        return "application/json"
    }

    init(key: String, url: String) {
        self.type = RequestType.fetch
        self.key = key
        self.url = url
    }

    func data() throws -> Data {
        parameters["url"] = url

        if isBinary {
            parameters["response"] = ["mode": "binary"]
        }

        return try JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}
