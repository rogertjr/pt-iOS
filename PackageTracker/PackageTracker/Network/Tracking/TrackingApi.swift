//
//  TrackingApi.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

enum TrackingApi {
    case fetchTrackings(_ isArchived: Bool)
    case createTracking(_ model: Package)
    case deleteTracking(_ trackingID: String)
}

extension TrackingApi {
    static let baseUrl = "https://api.trackingmore.com"
    static let apiVersion = "v4"
    
    var apiKey: String {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let key = infoDictionary["TRACKINGMORE_API_KEY"] as? String else { return "" }
        return key
    }
    
    var path: String {
        switch self {
        case .fetchTrackings:
            return String(format: "/%@/trackings/get",
                          TrackingApi.apiVersion)
        case .createTracking:
            return String(format: "/%@/trackings/create",
                          TrackingApi.apiVersion)
            
        case let .deleteTracking(trackingID):
            return String(format: "/%@/trackings/delete/%@",
                          TrackingApi.apiVersion,
                          trackingID)
        }
    }
    
    var method: String {
        switch self {
        case .fetchTrackings:
            return "GET"
        case .createTracking:
            return "POST"
        case .deleteTracking:
            return "DELETE"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .createTracking(model):
            return [
                .init(name: "note", value: model.note),
                .init(name: "title", value: model.title),
                .init(name: "language", value: "en"),
                .init(name: "courier_code", value: "brazil-correios"),
                .init(name: "order_number", value: model.orderNumber),
                .init(name: "customer_name", value: model.customerName),
                .init(name: "tracking_number", value: model.trackingNumber)
            ]
            
        case let .fetchTrackings(isArchived):
            return [
                .init(name: "archived_status", value: isArchived ? "true" : "tracking"),
                .init(name: "language", value: "en"),
                .init(name: "courier_code", value: "brazil-correios"),
                .init(name: "items_amount", value: "10")
            ]
        default:
            return nil
        }
    }
    
    var request: URLRequest? {
        guard var urlComponents = URLComponents(string: TrackingApi.baseUrl) else { return nil }
        urlComponents.path = path
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "Tracking-Api-Key")
        
        switch self {
        case .createTracking:
            guard let queryItems else { return nil }
            do {
                let data = try JSONSerialization.data(withJSONObject: queryItems, options: [])
                request.httpBody = data
            } catch {
                fatalError("🚨 - \(error.localizedDescription)")
            }
        default:
            urlComponents.queryItems = queryItems
        }
        
        return request
    }
}
