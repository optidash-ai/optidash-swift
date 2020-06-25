//
//  OptidashError.swift
//  Optidash
//
//  Created by Dawid Płatek on 19/11/2019.
//  Copyright © 2020 Optidash UG. All rights reserved.
//

enum OptidashError: Error {
    case requestTypeConflict
    case noPathProvided
    case operationNotSupported
    case invalidProxyUrl
    case cannotDetectFileSize
    case cannotCreateStreamFromFile
    case cannotReadStreamFromFile
    case unknownError
}
