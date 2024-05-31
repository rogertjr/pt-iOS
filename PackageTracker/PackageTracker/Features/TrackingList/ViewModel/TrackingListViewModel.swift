//
//  TrackingListViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import Foundation
import Combine

protocol TrackingListViewModelProtocol: ObservableObject {
    func fetchTrackings() async
}

final class TrackingListViewModel: TrackingListViewModelProtocol {
    // MARK: - Properties
    private let service: TrackingServiceProtocol
    
    @Published private(set) var state: State = .idle
    @Published var hasError: Bool = false
    @Published var trackings: [TrackingData] = []
    @Published var selectedTracking: TrackingData?
	
	var isLoading: Bool = false
	@Published var searchedText: String = ""
    @Published var searchedTrackings: [TrackingData]?
	@Published var selectedStatus: DeliveryStatus = .transit
    
    var subscriptions = Set<AnyCancellable>()
    
    enum State: Equatable {
        case idle
        case loading
        case success
        case failed(error: Error)
        case finishedLoading
        
        static func == (lhs: TrackingListViewModel.State,
                        rhs: TrackingListViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle),
                (.loading, .loading),
                (.success, .success),
                (.failed, .failed),
                (.finishedLoading, .finishedLoading):
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Init
    init(_ service: TrackingServiceProtocol) {
        self.service = service
        
        $searchedText
            .removeDuplicates()
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] search in
                guard let self else { return }
                if !search.isEmpty {
                    self.filterTrackings(by: search)
                } else {
                    self.searchedTrackings = nil
                }
                
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Helpers
    private func filterTrackings(by search: String) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            
            let result = self.trackings
                .lazy
                .filter { tracking in
                    return tracking.title?.lowercased().contains(search.lowercased()) ?? false
                }
            
            DispatchQueue.main.async { [weak self] in
                self?.searchedTrackings = result.compactMap({ $0 }).filter({ $0.deliveryStatus == self?.selectedStatus })
            }
        }
    }
    
    // MARK: - Network
	@MainActor
    func fetchTrackings() async {
        guard !isLoading else { return }
        state = .loading
        isLoading = true
        hasError = false
        
        defer {
            state = .finishedLoading
            isLoading = false
        }
        
        do {
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // for testing purposes ;)
            let data = try await service.fetchTrackings(false)
            guard let trackings = data else {
                self.state = .failed(error: TrackingService.NetworkingError.invalidData)
                self.hasError = true
                return
            }
            self.trackings = trackings
            self.state = .success
        } catch {
            self.hasError = true
            self.state = .failed(error: error)
        }
    }
}
