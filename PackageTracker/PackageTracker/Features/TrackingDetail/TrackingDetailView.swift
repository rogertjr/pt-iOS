//
//  TrackingDetailView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI

struct TrackingDetailView: View {
    // MARK: - Env
    var animation: Namespace.ID
    
    // MARK: - Properties
    @ObservedObject var viewModel: TrackingDetailViewModel = TrackingDetailViewModel(TrackingService())
    @EnvironmentObject var trackingListViewModel: TrackingListViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State var showDetailContent: Bool = false
    
    let tracking: Tracking
    
    // MARK: - Layout
    var body: some View {
        GeometryReader { proxy in
            switch viewModel.state {
            case .loading:
                LoadingView(backgroundColor: Color("Black"),
                            foregroundColor: .white,
                            title: "Carregando...")
            default:
                VStack {
                    buttonHeaderView
                    mapView(proxy.size)
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 10) {
                            packageHeaderView
                                .frame(maxWidth: .infinity,
                                       alignment: .leading)
                        }
                        
                        Divider()
                        
                        if let checkpoints = tracking.checkpoints, checkpoints.count > 0  {
                            List(checkpoints.reversed()) { checkpoint in
                                TrackingDetailCellView(checkpoint: checkpoint)
                            }
                            .frame( maxWidth: .infinity)
                            .edgesIgnoringSafeArea([.top, .leading, .trailing])
                            .listStyle(PlainListStyle())
                            .padding(.top, -10)
                        } else {
                            Text("Sem atualizações no momento :(")
                                .font(.subheadline.bold())
                                .foregroundColor(Color("Black"))
                        }
                    }
                    .padding(.top, 35)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .top)
                    .background {
                        RoundedRectangle(cornerRadius: 30,
                                         style: .continuous)
                            .fill(.white)
                            .ignoresSafeArea()
                    }
                }
                .opacity(showDetailContent ? 1 : 0)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .top)
            }
        }
        .background {
            Color("Black")
                .opacity(showDetailContent ? 1 : 0)
                .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut) {
                showDetailContent = true
            }
        }
        .alert("Erro", isPresented: $viewModel.hasError, presenting: viewModel.state) { detail in
            Button("Tentar novamente") {
                Task {
                    await viewModel.deleteTracking(tracking.trackingNumber ?? "")
                }
            }
        } message: { detail in
            if case let .failed(error) = detail {
                Text(error.localizedDescription)
            }
        }
    }
}

// MARK: - Subviews
private extension TrackingDetailView {
    var buttonHeaderView: some View {
        HStack {
            Button {
                withAnimation(.easeInOut) {
                    showDetailContent = false
                }
                withAnimation(.easeInOut.delay(0.07)) {
                    appViewModel.showTrackingDetailView = false
                }
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("Black"))
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
            }
            
            Spacer()
            
            Button {
                Task {
                    await viewModel.deleteTracking(tracking.trackingNumber ?? "")
                    
                    switch viewModel.state {
                    case let .success(tracking):
                        let filteredList = trackingListViewModel.trackings.filter({ $0.id != tracking.id })
                        trackingListViewModel.trackings = filteredList
                        
                        withAnimation(.easeInOut) {
                            showDetailContent = false
                        }
                        withAnimation(.easeInOut.delay(0.03)) {
                            appViewModel.showTrackingDetailView = false
                        }
                    default:
                        return
                    }
                }
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
            }
        }
        .padding()
        .opacity(showDetailContent ? 1 : 0)
    }
    
    @ViewBuilder
    func mapView(_ size: CGSize) -> some View {
        Image(systemName: "map")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .matchedGeometryEffect(id: tracking.id + "IMAGE", in: animation)
            .frame(height: size.height / 5)
            .foregroundColor(.white)
    }
    
    var packageHeaderView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(tracking.title ?? "")
                .font(.title.bold())
                .foregroundColor(Color("Black"))
                .fixedSize()
                .matchedGeometryEffect(id: tracking.id + "TITLE", in: animation)
                .lineLimit(1)
            
            Text(tracking.trackingNumber ?? "")
                .font(.caption2)
                .bold()
                .foregroundColor(.gray)
                .fixedSize()
                .matchedGeometryEffect(id: tracking.id + "TRACKING", in: animation)
        }
    }
}
