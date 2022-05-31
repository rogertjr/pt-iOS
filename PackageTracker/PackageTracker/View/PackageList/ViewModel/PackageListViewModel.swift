//
//  PackageListViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import Foundation

final class PackageListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentMenu: MenuType = .inTransit
    
    @Published private (set) var packages: [Package] = [Package.dummyData]
}
