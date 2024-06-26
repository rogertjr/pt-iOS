//
//  TrackingListView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI
import SwiftData
import Combine

struct TrackingListView: View {
    // MARK: - Properties
    @State var viewModel: TrackingListViewModel
    @Environment(NetworkMonitor.self) private var networkMonitor
    @AppStorage("needsRefresh") var needsRefresh: Bool = true
    @State private var isRotating: Bool = false
	private var addTrackingTip = AddTrackingTip()
    private var dummyTracking: TrackingData { TrackingResponseDTO.dummyData.first! }
    
    // MARK: - Init
    init(_ modelContext: ModelContext) { 
        let viewModel = TrackingListViewModel(TrackingService(), modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Layout
    var body: some View {
        NavigationStack {
			ScrollView {
				pickerView
				
				switch viewModel.state {
				case .loading:
					skeletonView()
				case .failed(let error):
					ContentUnavailableView(label: {
						Label(error.localizedDescription, systemImage: "exclamationmark.triangle")
					})
				default:
					listView
						.padding(.top, 8)
				}
			}
            .navigationTitle("Trackings")
            .searchable(text: $viewModel.searchedText, placement: .automatic)
            .autocorrectionDisabled(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: { refreshToolbarButton })
                
                ToolbarItem(placement: .navigationBarTrailing, content: { addToolbarButton })
            }
            .task {
				if viewModel.needsRefresh {
                    await viewModel.fetchFromRemote(networkMonitor.isConnected)
                } else {
                    await viewModel.fetchFromLocal()
                }
				
				if viewModel.searchedText.isEmpty && viewModel.trackings.count < 1 {
					AddTrackingTip.showTip = true
					await AddTrackingTip.numberOfTimesVisited.donate()
				}
            }
			.alert(isPresented: $viewModel.hasError) {
				Alert(title: Text("Oops!"),
					  message: Text("Something went wrong."),
					  primaryButton: .destructive(Text("Cancel"), action: { }),
					  secondaryButton: .default(Text("Try Again"), action: {
					Task {
                        await viewModel.fetchFromLocal()
					}
				}))
			}
        }
    }
}

// MARK: - Builders
private extension TrackingListView {
    @ViewBuilder
    var listView: some View {
        if !viewModel.searchedText.isEmpty, let searchedTrackings = viewModel.searchedTrackings {
			
			if !viewModel.searchedText.isEmpty && viewModel.searchedTrackings?.count == 0 {
				ContentUnavailableView.search(text: viewModel.searchedText)
					.deferredRendering(for: 0.8)
			} else {
				ForEach(searchedTrackings, id: \.id) { tracking in
					TrackingCardView(tracking: tracking, isLoading: $viewModel.isLoading)
				}
			}
        } else {
			if viewModel.trackings.count > 0 {
				ForEach(viewModel.trackings.filter({
					viewModel.selectedStatus != .delivered
					? $0.deliveryStatus != .delivered
					: $0.deliveryStatus == .delivered
				}), id: \.id) { tracking in
					SwipeAction(cornerRadius: 10, direction: .trailing) {
						NavigationLink {
							TrackingDetailView(tracking: tracking)
								.environmentObject(viewModel)
						} label: {
							TrackingCardView(tracking: tracking, isLoading: $viewModel.isLoading)
						}
					} actions: {
						Action(tint: .red, icon: "trash") {
							Task {
								await viewModel.deleteTracking(by: tracking.id)
							}
						}
					}
					
				}
			} else {
				ContentUnavailableView(label: {
					Label("No trackings where added yet", systemImage: "truck.box")
				})
			}
        }
    }
    
	var addToolbarButton: some View {
		NavigationLink(destination: {
			NewTrackingView()
				.environmentObject(viewModel)
		}) {
			Image(systemName: "plus")
				.font(.title3)
				.fontWeight(.semibold)
				.tint(.primary)
				.frame(width: 45, height: 45)
				.popoverTip(addTrackingTip, arrowEdge: .top)
		}
	}
	
    var refreshToolbarButton: some View {
        Button {
            Task {
                isRotating.toggle()
                await viewModel.fetchFromRemote(networkMonitor.isConnected)
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
			ForEach([DeliveryStatus.transit, DeliveryStatus.delivered], id: \.self) {
                Text($0.rawValue.localizedCapitalized)
            }
        } label: { Text("") }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        
    }
}

// MARK: - Preview
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TrackingData.self, configurations: config)
        
        return NavigationStack {
            TrackingListView(container.mainContext)
                .environment(NetworkMonitor())
                .tint(.primary)
                .modelContainer(container)
        }
        .preferredColorScheme(.dark)
    } catch {
        fatalError("Failed to build container")
    }
}
