//
//  Package.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 31/05/22.
//

import SwiftUI

struct Package: Codable {
	var note: String
    var title: String
	var language: String
	var courierCode: String
	var orderNumber: String
	var customerName: String
	var trackingNumber: String
	
	private enum CodingKeys: String, CodingKey {
		case note, title, language,
		case courierCode = "courier_code"
		case orderNumber = "order_number"
		case customerName = "customer_name"
		case trackingNumber = "tracking_number"
	}
}

//extension Package
