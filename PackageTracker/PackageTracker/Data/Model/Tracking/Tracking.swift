//
//  Tracking.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

// MARK: - TrackingResponse
struct TrackingResponse: Codable {
    let meta: Meta
    let data: [TrackingData]
}

extension TrackingResponse {
    static var dummyData: [TrackingData] {
        let response = try! JSONMapper.decode(MockResultFiles.fetchAllTrackings.rawValue, type: TrackingResponse.self)
        return response.data
    }
}

// MARK: - Datum
struct TrackingData: Codable {
    let id, trackingNumber, courierCode, orderNumber: String
    let orderDate, updateAt: String?
    let createdAt: String
    let deliveryStatus: DeliveryStatus
    let archived: String
    let updating: Bool?
    let destinationCountry, destinationState, destinationCity, originCountry: String?
    let originState, originCity, trackingPostalCode, trackingShipDate: String?
    let trackingDestinationCountry, trackingOriginCountry, trackingKey, trackingCourierAccount: String?
    let customerName: String?
    let customerEmail, customerSMS, recipientPostcode: String?
    let orderID, title, logisticsChannel, note: String?
    let label, signedBy, serviceCode, weight: String?
    let weightKg, productType, pieces, dimension: String?
    let previously, destinationTrackNumber, exchangeNumber, scheduledDeliveryDate: String?
    let scheduledAddress, statusInfo, latestEvent: String?
    let substatus: String?
    let latestCheckpointTime: String?
    let transitTime: Int?
    let originInfo, destinationInfo: NInfo?

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
        case destinationCountry = "destination_country"
        case destinationState = "destination_state"
        case destinationCity = "destination_city"
        case originCountry = "origin_country"
        case originState = "origin_state"
        case originCity = "origin_city"
        case trackingPostalCode = "tracking_postal_code"
        case trackingShipDate = "tracking_ship_date"
        case trackingDestinationCountry = "tracking_destination_country"
        case trackingOriginCountry = "tracking_origin_country"
        case trackingKey = "tracking_key"
        case trackingCourierAccount = "tracking_courier_account"
        case customerName = "customer_name"
        case customerEmail = "customer_email"
        case customerSMS = "customer_sms"
        case recipientPostcode = "recipient_postcode"
        case orderID = "order_id"
        case title
        case logisticsChannel = "logistics_channel"
        case note, label
        case signedBy = "signed_by"
        case serviceCode = "service_code"
        case weight
        case weightKg = "weight_kg"
        case productType = "product_type"
        case pieces, dimension, previously
        case destinationTrackNumber = "destination_track_number"
        case exchangeNumber = "exchange_number"
        case scheduledDeliveryDate = "scheduled_delivery_date"
        case scheduledAddress = "scheduled_address"
        case substatus
        case statusInfo = "status_info"
        case latestEvent = "latest_event"
        case latestCheckpointTime = "latest_checkpoint_time"
        case transitTime = "transit_time"
        case originInfo = "origin_info"
        case destinationInfo = "destination_info"
    }
}

// MARK: - NInfo
struct NInfo: Codable {
    let courierCode, courierPhone, weblink, referenceNumber: String?
    let milestoneDate: MilestoneDate?
    let pickupDateLegacy, departedAirportDateLegacy, arrivedAbroadDateLegacy, customsReceivedDateLegacy: String?
    let arrivedDestinationDateLegacy: String?
    let trackinfo: [TrackInfo]?

    enum CodingKeys: String, CodingKey {
        case courierCode = "courier_code"
        case courierPhone = "courier_phone"
        case weblink
        case referenceNumber = "reference_number"
        case milestoneDate = "milestone_date"
        case pickupDateLegacy = "pickup_date (Legacy)"
        case departedAirportDateLegacy = "departed_airport_date (Legacy)"
        case arrivedAbroadDateLegacy = "arrived_abroad_date (Legacy)"
        case customsReceivedDateLegacy = "customs_received_date (Legacy)"
        case arrivedDestinationDateLegacy = "arrived_destination_date (Legacy)"
        case trackinfo
    }
}

// MARK: - MilestoneDate
struct MilestoneDate: Codable {
    let inforeceivedDate, pickupDate, outfordeliveryDate, deliveryDate: String?
    let returningDate, returnedDate: String?

    enum CodingKeys: String, CodingKey {
        case inforeceivedDate = "inforeceived_date"
        case pickupDate = "pickup_date"
        case outfordeliveryDate = "outfordelivery_date"
        case deliveryDate = "delivery_date"
        case returningDate = "returning_date"
        case returnedDate = "returned_date"
    }
}

// MARK: - Trackinfo
struct TrackInfo: Hashable, Codable {
    let checkpointDate, checkpointDeliveryStatus, checkpointDeliverySubstatus, trackingDetail: String?
    let location, countryIso2, state, city: String?
    let zip, rawStatus: String?

    enum CodingKeys: String, CodingKey {
        case checkpointDate = "checkpoint_date"
        case checkpointDeliveryStatus = "checkpoint_delivery_status"
        case checkpointDeliverySubstatus = "checkpoint_delivery_substatus"
        case trackingDetail = "tracking_detail"
        case location
        case countryIso2 = "country_iso2"
        case state, city, zip
        case rawStatus = "raw_status"
    }
}

extension TrackInfo {
    static var dummyData: TrackInfo {
        return .init(checkpointDate: "2024-05-29T06:46:26-03:00",
                     checkpointDeliveryStatus: "delivered",
                     checkpointDeliverySubstatus: "delivered001",
                     trackingDetail:  "Objeto entregue ao destinatário",
                     location: "- SP",
                     countryIso2: nil,
                     state: nil,
                     city: nil,
                     zip: nil,
                     rawStatus: nil)
    }
}
enum DeliveryStatus: String, CaseIterable, Codable {
    case transit, delivered
}

// MARK: - Meta
struct Meta: Codable {
    let code: Int
    let message: String
}
