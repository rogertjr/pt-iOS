//
//  TrackingData.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import SwiftUI

struct TrackingDataResponse: Decodable {
    var data: TrackingData
}

struct TrackingData: Decodable {
    var tracking: Tracking
}

// MARK: - Dummy Data
extension TrackingDataResponse {
    static let dummyData: TrackingDataResponse = TrackingDataResponse(data: TrackingData(tracking: Tracking.dummyData))
}
