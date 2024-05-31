//
//  TrackingDetailView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let SP = CLLocationCoordinate2D(latitude: 23.555, longitude: 46.6396)
}

struct TrackingDetailView: View {
    // MARK: - Properties
    let tracking: TrackingData
    
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
            
            if let checkpoints = tracking.originInfo?.trackinfo {
                List {
                    Section("Checkpoints") {
                        ForEach(checkpoints, id: \.self) { checkpoint in
                            TrackingDetailCellView(info: checkpoint)
                        }
                    }
                }
            } else {
                ContentUnavailableView("No checkpoints yet", systemImage: "clock")
            }
        }
        .navigationTitle(tracking.title ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    return NavigationStack {
        TrackingDetailView(tracking: TrackingResponse.dummyData.first!)
    }
    .preferredColorScheme(.dark)
}
