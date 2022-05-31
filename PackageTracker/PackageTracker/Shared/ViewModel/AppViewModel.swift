//
//  AppViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 31/05/22.
//

import Foundation

final class AppViewModel: ObservableObject {
    // MARK: - Properties
    @Published var showPackageDetailView: Bool = false
}
