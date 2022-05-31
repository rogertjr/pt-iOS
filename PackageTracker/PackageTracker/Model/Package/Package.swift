//
//  Package.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 31/05/22.
//

import SwiftUI

struct Package: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var tracking: String
    var statusDetail: [PackageStatusDetail]
}

// MARK: - Dummy Data
extension Package {
    static let dummyData: Package = Package(title: "Nike Sneaker",
                                            tracking: "OU1234567891BR",
                                            statusDetail: PackageStatusDetail.dummyData)
}
