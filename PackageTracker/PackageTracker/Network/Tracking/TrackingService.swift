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
    func fetchTrackings() async throws -> [Tracking]?
    func fetchTracking(_ trackingNumber: String, carrier: Carrier) async throws -> Tracking?
    func saveNewTracking(_ model: Package) async throws -> Tracking
    func deleteTracking(_ trackingNumber: String, carrier: Carrier) async throws -> Tracking
}

struct TrackingService: TrackingServiceProtocol {
    /// Fetches all trackings
    func fetchTrackings() async throws -> [Tracking]? {
        let urlSession = URLSession.shared
        let endpoint = TrackingApi.fetchTrackings
        let (data, response) = try await urlSession.data(for: endpoint.request)
                
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                throw TrackingServiceError.invalidStatusCode
        }
        
        let trackingData = try JSONDecoder().decode(TrackingListDataResponse.self, from: data)
        return trackingData.data.trackings
    }
    
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
        
    /// Persists new tracking
    func saveNewTracking(_ model: Package) async throws -> Tracking {
        let urlSession = URLSession.shared
        let endpoint = TrackingApi.saveNewTracking(model)
        let (data, response) = try await urlSession.data(for: endpoint.request)
                
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
                throw TrackingServiceError.invalidStatusCode
        }
        
        let trackingData = try JSONDecoder().decode(TrackingDataResponse.self, from: data)
        return trackingData.data.tracking
    }
    
    /// Deletes a tracking by its number
    func deleteTracking(_ trackingNumber: String, carrier: Carrier) async throws -> Tracking {
        let urlSession = URLSession.shared
        let endpoint = TrackingApi.deleteTracking(trackingNumber, carrier: carrier)
        let (data, response) = try await urlSession.data(for: endpoint.request)
                
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                throw TrackingServiceError.invalidStatusCode
        }
        
        let trackingData = try JSONDecoder().decode(TrackingDataResponse.self, from: data)
        return trackingData.data.tracking
    }
}
