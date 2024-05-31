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
	@EnvironmentObject var appViewModel: AppViewModel
	@State private var isRotating: Bool = false
	//    var animation: Namespace.ID
	
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
					if viewModel.trackings.isEmpty {
						if !viewModel.seachedText.isEmpty {
							ContentUnavailableView.search(text: viewModel.seachedText)
						} else {
							ContentUnavailableView(label: {
								Label("No trackings where added yet", systemImage: "truck.box")
							})
						}
					} else {
						EmptyView()
					}
				}
			}
			.navigationTitle("Trackings")
			.searchable(text: $viewModel.seachedText, placement: .automatic)
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
				//				await viewModel.fetchTrackings()
			}
		}
	}
	
	var refreshToolbarButton: some View {
		Button {
			Task {
				isRotating.toggle()
				//							await viewModel.fetchTrackings()
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
			TrackingCardView(tracking: .dummyData, isLoading: .constant(true))
			TrackingCardView(tracking: .dummyData, isLoading: .constant(true))
			TrackingCardView(tracking: .dummyData, isLoading: .constant(true))
		}
	}
	
	var pickerView: some View {
		Picker(selection: $viewModel.selectedStatus) {
			ForEach(TrackingStatus.allCases, id: \.self) {
				Text($0.description)
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
//
//        VStack {
//            switch viewModel.state {
//            case .loading:
//                LoadingView(backgroundColor: Color("Background"),
//                            foregroundColor: Color("Black"),
//                            title: "Carregando...")
//                    .background {
//                        Color("Background")
//                            .ignoresSafeArea()
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                
//            case .success:
//                VStack(spacing: 16) {
//                    headerView
//                    searchBarView
//                    customMenu()
//                    
//                        if viewModel.trackings.count > 0 {
//                            let filteredTrackings = viewModel.filterTrackings()
//                            if filteredTrackings.count > 0 {
//                                List(filteredTrackings) { tracking in
//                                    TrackingCellView(tracking: tracking)
//                                        .environmentObject(viewModel)
//                                        .environmentObject(appViewModel)
//                                        .background {
//                                            Color("Background")
//                                                .ignoresSafeArea()
//                                        }
//                                        .listRowSeparator(.hidden)
//                                        .listRowBackground(Color("Background"))
//                                }
//                                .background {
//                                    Color("Background")
//                                        .ignoresSafeArea()
//                                }
//                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                .edgesIgnoringSafeArea([.leading, .trailing])
//                                .listStyle(PlainListStyle())
//                                .refreshable {
//                                    Task {
//                                        await viewModel.fetchTrackings()
//                                    }
//                                }
//                            } else {
//                                let title = viewModel.currentMenu == .delivered
//                                    ? "Não há encomendas entregues"
//                                    : "Não há encomendas em trânsito"
//                                emptyView(title)
//                            }
//                        } else {
//                            emptyView("Não há encomendas cadastradas")
//                        }
//                }
//                .background {
//                    Color("Background")
//                        .ignoresSafeArea()
//                }
//                .ignoresSafeArea(.keyboard, edges: .bottom)
//                
//            default:
//                EmptyView()
//            }
//        }
//        .overlay {
//            if let tracking = viewModel.selectedTracking, appViewModel.showTrackingDetailView {
//                TrackingDetailView(animation: animation,
//                                   tracking: tracking)
//                    .environmentObject(viewModel)
//                    .environmentObject(appViewModel)
//                    .transition(.pushTransition)
//            }
//            
//            if appViewModel.showNewTrackingView {
//                NewTrackingView()
//                    .environmentObject(viewModel)
//                    .environmentObject(appViewModel)
//                    .transition(.pushTransition)
//            }
//        }
//        .alert("Erro", isPresented: $viewModel.hasError, presenting: viewModel.state) { detail in
//            Button("Tentar novamente") {
//                Task {
//                    await viewModel.fetchTrackings()
//                }
//            }
//        } message: { detail in
//            if case let .failed(error) = detail {
//                Text(error.localizedDescription)
//            }
//        }
//        .task {
//            await viewModel.fetchTrackings()
//        }
//}



// MARK: - Subviews
//private extension TrackingListView {
//    @ViewBuilder
//    func emptyView(_ title: String) -> some View {
//        Text(title)
//            .font(.subheadline.bold())
//            .foregroundColor(Color("Black"))
//            .frame(maxWidth: .infinity,
//                   maxHeight: .infinity,
//                   alignment: .center)
//    }
//    
//    var headerView: some View {
//        HStack {
//            Text("Encomendas")
//                .font(.title.bold())
//                .foregroundColor(Color("Black"))
//            
//            Spacer()
//            
//            Button {
//                withAnimation(.easeInOut) {
//                    appViewModel.showNewTrackingView = true
//                }
//            } label: {
//                Image(systemName: "plus")
//                    .foregroundColor(Color("Black"))
//                    .padding(12)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10, style: .continuous)
//                            .fill(.white)
//                    }
//            }
//
//        }
//        .padding()
//    }
//    
//    var searchBarView: some View {
//        HStack(spacing: 12) {
//            Image(systemName: "magnifyingglass")
//                .resizable()
//                .renderingMode(.template)
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 25, height: 25)
//                .foregroundColor(Color("Black"))
//            
//            // TODO: - Handle search
//            TextField("Pesquisar", text: .constant(""))
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 12)
//        .background {
//            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .fill(.white)
//        }
//        .padding(.horizontal)
//    }
//    
//    @ViewBuilder
//    func customMenu() -> some View {
//        HStack(spacing: 0) {
//            ForEach(MenuType.allCases, id: \.self) { menu in
//                Text(menu.rawValue)
//                    .font(.callout)
//                    .fontWeight(.semibold)
//                    .foregroundColor(viewModel.currentMenu != menu ? Color("Black") : .white)
//                    .padding(.vertical,8)
//                    .frame(maxWidth: .infinity)
//                    .background {
//                        if viewModel.currentMenu == menu {
//                            Capsule()
//                                .fill(Color("Black"))
//                                .shadow(color: Color("Black").opacity(0.1), radius: 5, x: 5, y: 5)
//                                .matchedGeometryEffect(id: "MENU", in: animation)
//                        }
//                    }
//                    .opacity(viewModel.trackings.count > 0 ? 1 : 0.6)
//                    .onTapGesture {
//                        if viewModel.trackings.count > 0 {
//                            withAnimation(.easeInOut) { viewModel.currentMenu = menu }
//                        }
//                    }
//            }
//        }
//        .background {
//            Capsule()
//                .fill(Color.white)
//        }
//        .padding(.vertical, 10)
//        .padding(.horizontal)
//    }
//}
