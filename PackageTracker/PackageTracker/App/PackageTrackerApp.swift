//
//  PackageTrackerApp.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI

@main
struct PackageTrackerApp: App {
    // MARK: - Properties
    
    // MARK: - Layout
    var body: some Scene {
        WindowGroup {
            TrackingListView()
                .tint(.primary)
                .foregroundStyle(.primary)
				.preferredColorScheme(.dark)
        }
    }
}
