//
//  Tag.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 15/06/22.
//

import Foundation

enum Tag: String, Decodable, CaseIterable {
    case pending = "Pending"
    case infoReceived = "InfoReceived"
    case inTransit = "InTransit"
    case outForDelivery = "OutForDelivery"
    case attemptFail = "AttemptFail"
    case delivered = "Delivered"
    case availableForPickup = "AvailableForPickup"
    case `exception` = "Exception"
    case expired = "Expired"
}
