//
//  TrackingService.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

enum TrackingServiceError: Error {
    case failed
    case failedToDecode
    case invalidStatusCode
}

protocol TrackingServiceProtocol {
    func fetchTracking(_ trackingNumber: String, carrier: Carrier) async throws -> Tracking?
}

struct TrackingService: TrackingServiceProtocol {
    /// Fetches data from a tracking number
    func fetchTracking(_ trackingNumber: String, carrier: Carrier) async throws -> Tracking? {
        let urlSession = URLSession.shared
        let endpoint = TrackingApi.fetchTracking(trackingNumber, carrier: carrier)
        let (data, response) = try await urlSession.data(for: endpoint.request)
                
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                throw TrackingServiceError.invalidStatusCode
        }
        
        let trackingData = try JSONDecoder().decode(TrackingDataResponse.self, from: data)
        return trackingData.data.tracking
    }
}
