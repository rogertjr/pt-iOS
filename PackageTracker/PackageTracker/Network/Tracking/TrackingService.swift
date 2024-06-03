//
//  TrackingService.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

protocol TrackingServiceProtocol {
    func fetchTrackings(_ isArchived: Bool) async throws -> [TrackingData]?
    func createTracking(_ model: Package) async throws -> TrackingResponseDTO
    func deleteTracking(_ id: String) async throws -> TrackingData
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
        let dto = try JSONDecoder().decode(TrackingResponseDTO.self, from: data)
        
        var trackingData: [TrackingData] = []
        for data in dto.data { trackingData.append(.init(data: data)) }
        
        return trackingData
    }
    
    /// Persists new tracking
    func createTracking(_ model: Package) async throws -> TrackingResponseDTO {
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
        return try JSONDecoder().decode(TrackingResponseDTO.self, from: data)
    }
    
    /// Deletes a tracking by its number
	///
	func deleteTracking(_ id: String) async throws -> TrackingData {
		guard let endpointRequest = TrackingApi.deleteTracking(id).request else {
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
        let dto = try JSONDecoder().decode(DeleTrackingResponseDTO.self, from: data)
        
        return .init(data: dto.data)
	}
}


/*
 ====== REQUEST ======

URL: https://api.trackingmore.com/v4/trackings/delete/9c2cdcc6651a09e36a7f32cd7828fe78
HTTP METHOD: DELETE
HEADERS:
{
  "Content-Type" : "application\/json",
  "Accept" : "application\/json",
  "Tracking-Api-Key" : "mqoj8fr9-7efz-gywk-kd59-7n84j8o0xqb1"
}

 ====== RESPONSE ======

CODE: 200
HEADERS:
{
  "Date" : "Mon, 03 Jun 2024 16:41:27 GMT",
  "access-control-allow-methods" : "GET, POST, PUT, GET, OPTIONS, DELETE",
  "Content-Type" : "application\/json",
  "Access-Control-Allow-Origin" : "*",
  "Server" : "cloudflare",
  "Content-Encoding" : "gzip",
  "access-control-allow-headers" : "x-requested-with,content-type,tracking-api-key",
  "cf-ray" : "88e1217b8b6c628a-GRU",
  "cf-cache-status" : "DYNAMIC"
}
BODY:
{"meta":{"code":200,"message":"Request response is successful"},"data":{"id":"9c2cdcc6651a09e36a7f32cd7828fe78","tracking_number":"NM391959583BR","courier_code":"brazil-correios"}}

 ====== END ======
 
 */
