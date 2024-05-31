//
//  TrackingApi.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

enum TrackingApi {
    case fetchTrackings
    case fetchTracking(_ trackingNumber: String, carrier: Carrier)
    case createTracking(_ model: Package)
    case deleteTracking(_ trackingNumber: String, carrier: Carrier)
}

extension TrackingApi {
    static let baseUrl = "https://api.trackingmore.com"
    static let apiVersion = "v4"
    
    var path: String {
        switch self {
        case .fetchTrackings:
            return String(format: "/%@/trackings",
                          TrackingApi.apiVersion)
            
        case let .fetchTracking(trackingNumer, carrier):
            return String(format: "/%@/trackings/%@/%@",
                          TrackingApi.apiVersion,
                          carrier.rawValue,
                          trackingNumer)
            
        case .createTracking:
            return String(format: "/%@/trackings/create",
                          TrackingApi.apiVersion)
            
        case let .deleteTracking(trackingNumer, carrier):
            return String(format: "/%@/trackings/%@/%@",
                          TrackingApi.apiVersion,
                          carrier.rawValue,
                          trackingNumer)
        }
    }
    
    var method: String {
        switch self {
        case .fetchTrackings:
            return "GET"
        case .fetchTracking:
            return "GET"
        case .saveNewTracking:
            return "POST"
        case .deleteTracking:
            return "DELETE"
        }
    }
    
    var queryItems: [String: Any] {
        switch self {
        case let .saveNewTracking(model):
            return ["tracking": [
                "tracking_number": model.tracking,
                "title": model.title,
                "language": "pt"
                ]
            ]
        default:
            return [:]
        }
    }
    
    var request: URLRequest {
        var urlComponents = URLComponents(string: TrackingApi.baseUrl)!
        urlComponents.path = path
    
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(AFTERSHIP_KEY, forHTTPHeaderField: "aftership-api-key")
        request.addValue("pt", forHTTPHeaderField: "lang")
        
        if case .saveNewTracking = self {
            do {
                let trackingData = try JSONSerialization.data(withJSONObject: queryItems, options: [])
                request.httpBody = trackingData
            } catch {
                fatalError("🚨 - \(error.localizedDescription)")
            }
        }
        return  request
    }
}
