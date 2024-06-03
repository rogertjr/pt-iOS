//
//  CustomError.swift
//  PackageTracker
//
//  Created by Rogério do Carmo Toledo Júnior on 03/06/24.
//

import Foundation

enum CustomError: Error, CustomStringConvertible, LocalizedError {
    case unexpected
    
    var description: String {
        switch self {
        case .unexpected:
            return "Unexpected error"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unexpected:
            return NSLocalizedString("An Unexpected error occured", comment: "TBD")
        }
    }
}
