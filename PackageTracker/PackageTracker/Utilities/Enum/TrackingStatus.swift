//
//  TrackingStatus.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/24.
//

import Foundation

enum TrackingStatus: String, CaseIterable {
	case active, delivered
	
	var description: String {
		return self.rawValue.localizedCapitalized
	}
}
