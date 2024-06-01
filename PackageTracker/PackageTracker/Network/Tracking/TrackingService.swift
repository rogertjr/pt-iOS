//
//  TrackingService.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

protocol TrackingServiceProtocol {
    func fetchTrackings(_ isArchived: Bool) async throws -> [TrackingData]?
    func createTracking(_ model: Package) async throws -> TrackingResponse
//    func deleteTracking(_ id: String) async throws -> Tracking
}

extension TrackingServiceProtocol {
    func debugLog(_ request: URLRequest, response: HTTPURLResponse? = nil, responseData: Data? = nil, error: Error? = nil) {
        print("\n ====== REQUEST ====== \n")
        defer { print("\n ====== END ====== \n") }
        
        print("URL: \(request.url?.absoluteString ?? "")")
        print("HTTP METHOD: \(request.httpMethod ?? "")")
        
        if let requestHeaders = request.allHTTPHeaderFields,
           let headersData = try? JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted),
           let headersDataString = String(data: headersData, encoding: .utf8) {
            print("HEADERS: \n\(headersDataString)")
        }
        
        if let requestBodyData = request.httpBody,
           let requestBody = String(data: requestBodyData, encoding: .utf8) {
            print("BODY: \n\(requestBody)")
        }
        
        if let httpResponse = response {
            print("\n ====== RESPONSE ====== \n")
            print("CODE: \(httpResponse.statusCode)")
            
            if let headersData = try? JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: .prettyPrinted),
               let headersDataString = String(data: headersData, encoding: .utf8) {
                print("HEADERS: \n\(headersDataString)")
            }
            
            if let responseBodyData = responseData,
               let responseBody = String(data: responseBodyData, encoding: .utf8) {
                print("BODY: \n\(responseBody)")
            }
        }
        
        if let urlError = error as? URLError {
            print("\n ====== ERROR =======")
            print("CODE: \(urlError.errorCode)")
            print("DESCRIPTION: \(urlError.localizedDescription)\n")
        } else if let error = error as? TrackingService.NetworkingError {
            print("\n ====== ERROR =======")
            if case let .invalidStatusCode(int) = error {
                print("CODE: \(int)")
            }
            print("DESCRIPTION: \(error.localizedDescription)\n")
        }
    }
}

struct TrackingService: TrackingServiceProtocol {
    /// Fetches all trackings
    func fetchTrackings(_ isArchived: Bool) async throws -> [TrackingData]? {
        guard let endpointRequest = TrackingApi.fetchTrackings(isArchived).request else {
            throw NetworkingError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(for: endpointRequest)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            debugLog(endpointRequest, error: NetworkingError.invalidStatusCode(statusCode))
            throw NetworkingError.invalidStatusCode(statusCode)
        }
        
        debugLog(endpointRequest,response: response, responseData: data)
        return try JSONDecoder().decode(TrackingResponse.self, from: data).data
    }
    
    /// Persists new tracking
    func createTracking(_ model: Package) async throws -> TrackingResponse {
        guard let endpointRequest = TrackingApi.createTracking(model).request else {
            throw NetworkingError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: endpointRequest)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            debugLog(endpointRequest, error: NetworkingError.invalidStatusCode(statusCode))
            throw NetworkingError.invalidStatusCode(statusCode)
        }
        
        debugLog(endpointRequest,response: response, responseData: data)
        return try JSONDecoder().decode(TrackingResponse.self, from: data)
    }
    
    /// Deletes a tracking by its number
//    func deleteTracking(_ trackingNumber: String, carrier: Carrier) async throws -> Tracking {
//        let urlSession = URLSession.shared
//        let endpoint = TrackingApi.deleteTracking(trackingNumber, carrier: carrier)
//        let (data, response) = try await urlSession.data(for: endpoint.request)
//                
//        guard let response = response as? HTTPURLResponse,
//              response.statusCode == 200 else {
//                throw TrackingServiceError.invalidStatusCode
//        }
//        
//        let trackingData = try JSONDecoder().decode(TrackingDataResponse.self, from: data)
//        return trackingData.data.tracking
//    }
}
