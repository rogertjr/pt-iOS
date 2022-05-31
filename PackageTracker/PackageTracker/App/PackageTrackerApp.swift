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
    @Namespace var animation
    
    // MARK: - Layout
    var body: some Scene {
        WindowGroup {
            PackageListView(animation: animation)
        }
    }
}
