//
//  TrackingApi.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

enum TrackingApi {
    case fetchTracking(_ trackingNumber: String, carrier: Carrier)
    case saveNewTracking(_ model: Package)
}

extension TrackingApi {
    static let baseUrl = "https://api.aftership.com"
    static let apiVersion = "v4"
    
    var path: String {
        switch self {
        case let .fetchTracking(trackingNumer, carrier):
            return String(format: "/%@/trackings/%@/%@",
                          TrackingApi.apiVersion,
                          carrier.rawValue,
                          trackingNumer)
        case .saveNewTracking:
            return String(format: "/%@/trackings", TrackingApi.apiVersion)
        }
    }
    
    var method: String {
        switch self {
        case .fetchTracking:
            return "GET"
        case .saveNewTracking:
            return "POST"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case let .saveNewTracking(model):
            return [
                "tracking_number": model.tracking,
                "title": model.title,
                "language": "pt",
            ].map(URLQueryItem.init)
        default:
            return []
        }
    }
    
    var request: URLRequest {
        var urlComponents = URLComponents(string: TrackingApi.baseUrl)!
        urlComponents.path = path
    
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method
        if case .saveNewTracking = self {
            // TODO: FIXXX
            // urlComponents.queryItems = ["tracking": queryItems]
            urlComponents.queryItems = queryItems
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(AFTERSHIP_KEY, forHTTPHeaderField: "aftership-api-key")
        request.addValue("pt", forHTTPHeaderField: "lang")
        return  request
    }
}
