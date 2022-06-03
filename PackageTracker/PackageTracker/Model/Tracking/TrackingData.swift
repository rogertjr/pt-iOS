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
    var tracking: Tracking?
}
