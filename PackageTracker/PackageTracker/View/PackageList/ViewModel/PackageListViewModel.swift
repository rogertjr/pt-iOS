//
//  PackageListViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import Foundation

final class PackageListViewModel: ObservableObject {
    
    @Published var currentMenu: MenuType = .inTransit
}
