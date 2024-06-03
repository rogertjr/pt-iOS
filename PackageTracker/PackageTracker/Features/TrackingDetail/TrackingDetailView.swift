//
//  TrackingDetailView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI
import MapKit
import SwiftData

extension CLLocationCoordinate2D {
    static let SP = CLLocationCoordinate2D(latitude: 23.555, longitude: 46.6396)
}

struct TrackingDetailView: View {
    // MARK: - Properties
    let tracking: TrackingData
    @EnvironmentObject var viewModel: TrackingListViewModel
	@Environment(\.dismiss) private var dismiss
    
    private var checkpointLocation: String? {
        guard let location = tracking.originInfo?.trackinfo?.first?.location,
              let index = location.lastIndex(of: " ") else { return nil }
        return String(location.suffix(from: index))
    }
    
    // MARK: - Layout
    var body: some View {
        ScrollViewReader { _ in
            Map {
                Marker(checkpointLocation ?? "N/a", coordinate: .SP)
                Annotation(checkpointLocation ?? "", coordinate: .SP) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.detailBackground)
                        Image(systemName: "cube.box")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
            .frame(height: 250)
            
			if let checkpoints = tracking.originInfo?.trackinfo, checkpoints.count > 0 {
                List {
                    Section("Checkpoints") {
                        ForEach(checkpoints, id: \.self) { checkpoint in
                            TrackingDetailItemView(info: checkpoint)
                        }
                    }
                }
            } else {
                ContentUnavailableView("No checkpoints yet", systemImage: "clock")
            }
        }
        .navigationTitle(tracking.title ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: {
					Task {
						await viewModel.deleteTracking(by: tracking.id)
						if viewModel.state == .success || viewModel.state == .finishedLoading {
							dismiss()
						}
					}
				}, label: {
					Image(systemName: "trash")
						.resizable()
						.tint(.primary)
				})
			}
		}
    }
}

// MARK: - Preview
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TrackingData.self, configurations: config)
        
        let viewModel = TrackingListViewModel(TrackingService(),
                                                               modelContext: container.mainContext)
        let data = TrackingResponseDTO.dummyData.first!
        
        return NavigationStack {
            TrackingDetailView(tracking: data)
            NewTrackingView()
                .environmentObject(viewModel)
        }
        .preferredColorScheme(.dark)
    } catch {
        fatalError("Failed to build container")
    }
}
