//
//  TrackingListViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

protocol TrackingListViewModelProtocol: ObservableObject {
    func fetchFromRemote(_ isConnected: Bool) async
    func fetchFromLocal() async
    func createTracking() async
    func deleteTracking(by id: String) async
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
    var isAbleToContinue: Bool { !trackingNumber.isEmpty && !packageName.isEmpty }
    
    var isLoading: Bool = false
    @AppStorage("needsRefresh") var needsRefresh: Bool = true
    
    var modelContext: ModelContext
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(_ service: TrackingServiceProtocol, modelContext: ModelContext) {
        self.service = service
        self.modelContext = modelContext
        
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
    
    // MARK: - Networking
    @MainActor
    func fetchFromRemote(_ isConnected: Bool) async {
        if isConnected {
            guard !isLoading else { return }
            state = .loading
            isLoading = true
            hasError = false
            
            defer {
                state = .idle
                isLoading = false
                needsRefresh = false
            }
            
            do {
                let data = try await service.fetchTrackings(false)
                guard let trackings = data else {
                    self.state = .failed(error: TrackingService.NetworkingError.invalidData)
                    self.hasError = true
                    return
                }
                
                for tracking in trackings {
                    modelContext.insert(tracking)
                }
                
                try modelContext.save()
                await fetchFromLocal()
                
                self.state = .success
            } catch {
                await fetchFromLocal()
            }
        } else {
            await fetchFromLocal()
        }
    }
    
    @MainActor
    func fetchFromLocal() async {
        isLoading = true
        hasError = false
        state = .loading
        
        defer {
            state = .idle
            isLoading = false
            needsRefresh = false
        }
        
        do {
            let descriptor = FetchDescriptor<TrackingData>(sortBy: [SortDescriptor(\.title)])
            trackings = try modelContext.fetch(descriptor)
            self.state = .success
        } catch {
            self.hasError = true
            self.state = .failed(error: CustomError.unexpected)
        }
    }
    
    @MainActor
    func createTracking() async {
        state = .loading
        isLoading = true
        hasError = false
        
        defer {
            state = .idle
            isLoading = false
            needsRefresh = true
        }
        
        do {
            let model = Package(title: packageName, trackingNumber: trackingNumber)
            let response = try await service.createTracking(model)
            
            for data in response.data {
                modelContext.insert(TrackingData(data: data))
            }
            
            try modelContext.save()
            await fetchFromLocal()

            self.state = .success
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    @MainActor
    func deleteTracking(by id: String) async {
        state = .loading
        isLoading = true
        hasError = false
        
        defer {
            state = .idle
            isLoading = false
            needsRefresh = false
        }
        
        do {
            let response = try await service.deleteTracking(id)
            let id: String = response.id.description
            
            try modelContext.delete(model: TrackingData.self, where: #Predicate { $0.id == id })
            await fetchFromLocal()
            
            self.state = .success
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
