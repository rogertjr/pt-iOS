//
//  NewTrackingViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 02/06/22.
//

import Foundation

protocol NewTrackingViewModelProtocol: ObservableObject {
    func saveNewTracking() async
}

@MainActor
final class NewTrackingViewModel: NewTrackingViewModelProtocol {
    // MARK: - Properties
    private let service: TrackingServiceProtocol
    
    @Published var trackingNumber: String = ""
    @Published var packageName: String = ""
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    var isAbleToContinue: Bool {
        !trackingNumber.isEmpty && !packageName.isEmpty
    }
    
    enum State: Equatable {
        case na
        case loading
        case success(tracking: TrackingData)
        case failed(error: Error)
        
        static func == (lhs: NewTrackingViewModel.State,
                        rhs: NewTrackingViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.na, .na):
                return true
            case (.loading, .loading):
                return true
            case (.success, .success):
                return true
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Init
    init(_ service: TrackingServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Network
    func saveNewTracking() async {
//        state = .loading
//        hasError = false
//        
//        do {
//            let model = Package(title: packageName, tracking: trackingNumber)
//            let tracking = try await service.saveNewTracking(model)
//            
//            self.state = .success(tracking: tracking)
//        } catch {
//            self.state = .failed(error: error)
//            self.hasError = true
//        }
    }
}
