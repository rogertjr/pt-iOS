//
//  TrackingListView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI

struct TrackingListView: View {
    // MARK: - Properties
    @StateObject var viewModel: TrackingListViewModel = TrackingListViewModel(TrackingService())
    @State private var isRotating: Bool = false
    
    private var dummyTracking: TrackingData {
        TrackingResponse.dummyData.first!
    }
    
    // MARK: - Layout
    var body: some View {
        NavigationStack {
            ScrollView {
                pickerView
                
                Divider()
                    .padding(.vertical)
                
                switch viewModel.state {
                case .loading:
                    skeletonView()
                case .failed(let error):
                    ContentUnavailableView(label: {
                        Label(error.localizedDescription, systemImage: "exclamationmark.triangle")
                    })
                default:
                    listView
                }
            }
            .navigationTitle("Trackings")
            .searchable(text: $viewModel.searchedText, placement: .automatic)
            .autocorrectionDisabled(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: { refreshToolbarButton })
                
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    NavigationLink(destination: { EmptyView() }) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .tint(.primary)
                            .frame(width: 45, height: 45)
                        //							.popoverTip(addTransactionTip, arrowEdge: .top)
                    }
                })
            }
            .task {
                await viewModel.fetchTrackings()
            }
        }
    }
}

private extension TrackingListView {
    @ViewBuilder
    var listView: some View {
        if !viewModel.searchedText.isEmpty,
           let searchedTrackings = viewModel.searchedTrackings,
           searchedTrackings.count > 0 {
            
            VStack {
                ForEach(searchedTrackings, id: \.id) { tracking in
                    TrackingCardView(tracking: tracking, isLoading: $viewModel.isLoading)
                }
            }
        } else if !viewModel.searchedText.isEmpty && viewModel.searchedTrackings == nil {
            ContentUnavailableView.search(text: viewModel.searchedText)
                .deferredRendering(for: 0.8)
        } else {
            VStack {
                if viewModel.trackings.count > 0 {
                    ForEach(viewModel.trackings, id: \.id) { tracking in
                        NavigationLink {
                            TrackingDetailView(tracking: tracking)
                        } label: {
                            TrackingCardView(tracking: tracking, isLoading: $viewModel.isLoading)
                        }
                    }
                } else {
                    ContentUnavailableView(label: {
                        Label("No trackings where added yet",
                              systemImage: "truck.box")
                    })
                }
            }
        }
    }
    
    
    var refreshToolbarButton: some View {
        Button {
            Task {
                isRotating.toggle()
                await viewModel.fetchTrackings()
            }
        } label: {
            Image(systemName: "goforward")
                .font(.caption)
                .tint(.primary)
                .rotationEffect(Angle.degrees(isRotating ? 360 : 0))
                .animation(.easeOut, value: isRotating)
        }
    }
    
    @ViewBuilder
    func skeletonView() -> some View {
        VStack {
            TrackingCardView(tracking: dummyTracking, isLoading: .constant(true))
            TrackingCardView(tracking: dummyTracking, isLoading: .constant(true))
            TrackingCardView(tracking: dummyTracking, isLoading: .constant(true))
        }
    }
    
    var pickerView: some View {
        Picker(selection: $viewModel.selectedStatus) {
            ForEach(DeliveryStatus.allCases, id: \.self) {
                Text($0.rawValue.localizedCapitalized)
            }
        } label: { Text("") }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TrackingListView()
    }
    .preferredColorScheme(.dark)
}
