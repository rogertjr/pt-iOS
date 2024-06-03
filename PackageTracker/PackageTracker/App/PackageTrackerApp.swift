//
//  PackageTrackerApp.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI
import TipKit
import SwiftData

@main
struct PackageTrackerApp: App {
	// MARK: - Properties
    let container: ModelContainer
    @State private var networkMonitor = NetworkMonitor()
    
	// MARK: - Init
	init() {
		try? Tips.configure()
        do {
            container = try ModelContainer(for: TrackingData.self)
        } catch {
            fatalError("Failed to create container for TrackingData")
        }
	}
	
	// MARK: - Layout
	var body: some Scene {
		WindowGroup {
            TrackingListView(container.mainContext)
                .environment(networkMonitor)
				.tint(.primary)
				.foregroundStyle(.primary)
				.preferredColorScheme(.dark)
		}
        .modelContainer(container)
	}
}
