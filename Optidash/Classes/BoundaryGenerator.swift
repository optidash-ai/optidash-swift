//
//  BoundaryGenerator.swift
//  Optidash
//
//  Created by Dawid Płatek on 19/12/2019.
//  Copyright © 2020 Optidash UG. All rights reserved.
//

import Foundation

struct EncodingCharacters {
    static let crlf = "\r\n"
}

struct BoundaryGenerator {
    enum BoundaryType {
        case initial, encapsulated, final
    }

    static func randomBoundary() -> String {
        return String(format: "optidash.boundary.%08x%08x", arc4random(), arc4random())
    }

    static func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
        let boundaryText: String

        switch boundaryType {
        case .initial:
            boundaryText = "--\(boundary)\(EncodingCharacters.crlf)"
        case .encapsulated:
            boundaryText = "\(EncodingCharacters.crlf)--\(boundary)\(EncodingCharacters.crlf)"
        case .final:
            boundaryText = "\(EncodingCharacters.crlf)--\(boundary)--\(EncodingCharacters.crlf)"
        }

        return Data(boundaryText.utf8)
    }
}
