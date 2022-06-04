//
//  TrackingListDataResponse.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import SwiftUI

struct TrackingListDataResponse: Decodable {
    var data: TrackingListData
}

struct TrackingListData: Decodable {
    var trackings: [Tracking]?
}

// MARK: - Dummy Data
extension TrackingListDataResponse {
    static let dummyData: TrackingListDataResponse = TrackingListDataResponse(data: TrackingListData(trackings: [Tracking.dummyData]))
}

