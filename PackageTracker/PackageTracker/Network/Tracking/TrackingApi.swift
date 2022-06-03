//
//  TrackingApi.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

enum TrackingApi {
    case fetchTracking(_ trackingNumber: String, carrier: Carrier)
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
        }
    }
    
    var method: String {
        switch self {
        case .fetchTracking:
            return "GET"
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
        return  request
    }
}
