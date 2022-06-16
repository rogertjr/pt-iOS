//
//  Tracking.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

struct Tracking: Identifiable, Decodable {
    var id: String
    var expectedDelivery: String?
    var trackingNumber: String?
    var tag: Tag?
    var subtagMessage: String?
    var title: String?
    var checkpoints: [Checkpoint]? = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case expectedDelivery = "expected_delivery"
        case trackingNumber = "tracking_number"
        case tag
        case subtagMessage = "subtag_message"
        case title
        case checkpoints
    }
}

// MARK: - Dummy Data
extension Tracking {
    static let dummyData: Tracking = Tracking(id: "asdasd123asd12",
                                              expectedDelivery: nil,
                                              trackingNumber: "OU317658744BR",
                                              tag: .delivered,
                                              subtagMessage: "Picked up by customer",
                                              title: "Test",
                                              checkpoints: [Checkpoint.dummyData])
}
