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
    
    @Published private(set) var state: ViewState = .idle
    @Published var hasError: Bool = false
    @Published var trackings: [TrackingData] = []
    @Published var selectedTracking: TrackingData?
	@Published var searchedText: String = ""
    @Published var searchedTrackings: [TrackingData]?
	@Published var selectedStatus: DeliveryStatus = .transit
	
	@Published var trackingNumber: String = ""
	@Published var packageName: String = ""
	var isAbleToContinue: Bool {
		!trackingNumber.isEmpty && !packageName.isEmpty
	}
	
	var isLoading: Bool = false
	var needsRefresh: Bool = true
    
    var subscriptions = Set<AnyCancellable>()
    
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
			needsRefresh = false
        }
        
        do {
//            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // for testing purposes ;)
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
	
	@MainActor
	func createTracking() async {
		state = .loading
		isLoading = true
		hasError = false
		
		defer {
			state = .finishedLoading
			isLoading = false
			needsRefresh = true
		}
		
		do {
			try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // for testing purposes ;)
			let model = Package(title: packageName, trackingNumber: trackingNumber)
//			_ = try await service.createTracking(model)
			
			self.state = .success
		} catch {
			self.state = .failed(error: error)
			self.hasError = true
		}
	}
	
	@MainActor
	func deleteTracking(by id: String) async {
		
		defer {
			state = .finishedLoading
			isLoading = false
			needsRefresh = true
		}
	}
	
}
