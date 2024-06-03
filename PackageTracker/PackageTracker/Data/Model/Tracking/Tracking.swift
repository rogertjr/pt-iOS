//
//  Tracking.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation
import SwiftData

// MARK: - TrackingResponse
struct TrackingResponseDTO: Codable {
    let meta: MetaDTO
    let data: [TrackingDataDTO]
}

extension TrackingResponseDTO {
    static var dummyData: [TrackingData] {
        let decodedData = try! JSONMapper.decode(MockResultFiles.fetchAllTrackings.rawValue, type: TrackingResponseDTO.self)
        var resultData: [TrackingData] = []
        for data in decodedData.data {
            resultData.append(.init(data: data))
        }
        return resultData
    }
}

struct DeleTrackingResponseDTO: Codable {
    let meta: MetaDTO
    let data: TrackingDataDTO
}

// MARK: - Meta
struct MetaDTO: Codable {
    let code: Int
    let message: String
}

struct TrackingDataDTO: Identifiable, Codable {
    let id, trackingNumber, courierCode: String
    let orderNumber, orderDate, updateAt: String?
    let createdAt: String?
    let deliveryStatus: DeliveryStatus?
    let archived: String?
    let updating: Bool?
    let originState, originCity: String?
    let title: String?
    let statusInfo, latestEvent: String?
    let substatus: String?
    let latestCheckpointTime: String?
    let transitTime: Int?
    let originInfo: NInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case trackingNumber = "tracking_number"
        case courierCode = "courier_code"
        case orderNumber = "order_number"
        case orderDate = "order_date"
        case createdAt = "created_at"
        case updateAt = "update_at"
        case deliveryStatus = "delivery_status"
        case archived, updating
        case originState = "origin_state"
        case originCity = "origin_city"
        case title
        case substatus
        case statusInfo = "status_info"
        case latestEvent = "latest_event"
        case latestCheckpointTime = "latest_checkpoint_time"
        case transitTime = "transit_time"
        case originInfo = "origin_info"
    }
}

// MARK: - Datum
@Model
class TrackingData {
    @Attribute(.unique) var id: String
    var trackingNumber: String
    var courierCode: String
    var orderNumber: String?
    var orderDate: String?
    var updateAt: String?
    var createdAt: String?
    var deliveryStatus: DeliveryStatus?
    var archived: String?
    var updating: Bool?
    var originState: String?
    var originCity: String?
    var title: String?
    var statusInfo: String?
    var latestEvent: String?
    var substatus: String?
    var latestCheckpointTime: String?
    var transitTime: Int?
    var originInfo: NInfo?

    init(id: String, 
         trackingNumber: String,
         courierCode: String,
         orderNumber: String? = nil,
         orderDate: String? = nil,
         updateAt: String? = nil,
         createdAt: String? = nil,
         deliveryStatus: DeliveryStatus? = nil,
         archived: String? = nil,
         updating: Bool? = nil,
         originState: String? = nil,
         originCity: String? = nil,
         title: String? = nil,
         statusInfo: String? = nil,
         latestEvent: String? = nil, 
         substatus: String? = nil,
         latestCheckpointTime: String? = nil,
         transitTime: Int? = nil,
         originInfo: NInfo? = nil) {
        self.id = id
        self.trackingNumber = trackingNumber
        self.courierCode = courierCode
        self.orderNumber = orderNumber
        self.orderDate = orderDate
        self.updateAt = updateAt
        self.createdAt = createdAt
        self.deliveryStatus = deliveryStatus
        self.archived = archived
        self.updating = updating
        self.originState = originState
        self.originCity = originCity
        self.title = title
        self.statusInfo = statusInfo
        self.latestEvent = latestEvent
        self.substatus = substatus
        self.latestCheckpointTime = latestCheckpointTime
        self.transitTime = transitTime
        self.originInfo = originInfo
    }
    
    convenience init(data: TrackingDataDTO) {
        self.init(id: data.id, trackingNumber: data.trackingNumber, courierCode: data.courierCode, orderNumber: data.orderNumber, orderDate: data.orderDate, updateAt: data.updateAt, createdAt: data.createdAt, deliveryStatus: data.deliveryStatus, archived: data.archived, updating: data.updating, originState: data.originState, originCity: data.originCity, title: data.title, statusInfo: data.statusInfo, latestEvent: data.latestEvent, substatus: data.substatus, latestCheckpointTime: data.latestCheckpointTime, transitTime: data.transitTime, originInfo: data.originInfo)
    }
}

// MARK: - NInfo
struct NInfo: Codable {
    let trackinfo: [TrackInfo]?

    enum CodingKeys: String, CodingKey {
        case trackinfo
    }
}

// MARK: - Trackinfo
struct TrackInfo: Hashable, Codable {
    let checkpointDate, checkpointDeliveryStatus, checkpointDeliverySubstatus, trackingDetail: String?
    let location : String?

    enum CodingKeys: String, CodingKey {
        case checkpointDate = "checkpoint_date"
        case checkpointDeliveryStatus = "checkpoint_delivery_status"
        case checkpointDeliverySubstatus = "checkpoint_delivery_substatus"
        case trackingDetail = "tracking_detail"
        case location
    }
}

extension TrackInfo {
    static var dummyData: TrackInfo {
        return .init(checkpointDate: "2024-05-29T06:46:26-03:00",
                     checkpointDeliveryStatus: "delivered",
                     checkpointDeliverySubstatus: "delivered001",
                     trackingDetail:  "Objeto entregue ao destinatário",
                     location: "- SP")
    }
}

enum DeliveryStatus: String, CaseIterable, Codable {
    case transit, delivered, pending
	case inforeceived, pickup, undelivered
	case exception, expired, notfound
}
