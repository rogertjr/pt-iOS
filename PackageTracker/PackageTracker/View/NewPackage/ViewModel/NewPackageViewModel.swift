//
//  NewPackageViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 02/06/22.
//

import Foundation

final class NewPackageViewModel: ObservableObject {
    // MARK: - Properties
    @Published var tracking: String = ""
    @Published var packageName: String = ""
    
    var isAbleToContinue: Bool {
        !tracking.isEmpty && !packageName.isEmpty
    }
    
    // MARK: - Network
    func saveNewPackage() {}
}
