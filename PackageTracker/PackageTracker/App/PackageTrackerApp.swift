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
//    @Namespace var animation
    @StateObject var appViewModel = AppViewModel()
    
    // MARK: - Layout
    var body: some Scene {
        WindowGroup {
            TrackingListView()
                .environmentObject(appViewModel)
				.preferredColorScheme(.dark)
        }
    }
}
