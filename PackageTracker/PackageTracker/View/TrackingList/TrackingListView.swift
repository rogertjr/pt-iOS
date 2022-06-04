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
    var animation: Namespace.ID
    
    // MARK: - Layout
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch viewModel.state {
            case .loading:
                loadingView
            case .success:
                VStack(spacing: 16) {
                    headerView
                    searchBarView
                    customMenu()
                    
                    if viewModel.trackings.count > 0 {
                        ForEach(viewModel.trackings) { tracking in
                            TrackingCellView(tracking: tracking)
                                .environmentObject(appViewModel)
                        }
                    } else {
                        emptyView
                    }
                }
            default:
                EmptyView()
            }
        }
        .background {
            Color("Background")
                .ignoresSafeArea()
        }
        .overlay {
            // TODO: Validate from selected tracking
            if let tracking = viewModel.trackings.first, appViewModel.showTrackingDetailView {
                TrackingDetailView(animation: animation,
                                   tracking: tracking)
                    .environmentObject(appViewModel)
                    .transition(.offset(x: 1, y: 1))
            }
            
            if appViewModel.showNewTrackingView {
                NewTrackingView()
                    .environmentObject(viewModel)
                    .environmentObject(appViewModel)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .alert("Erro", isPresented: $viewModel.hasError, presenting: viewModel.state) { detail in
            Button("Tentar novamente") {
                Task {
                    await viewModel.fetchTrackings()
                }
            }
        } message: { detail in
            if case let .failed(error) = detail {
                Text(error.localizedDescription)
            }
        }
        .task {
            await viewModel.fetchTrackings()
        }
    }
}

// MARK: - Subviews
private extension TrackingListView {
    var emptyView: some View {
        Text("Não há encomendas cadastradas")
            .font(.subheadline.bold())
            .foregroundColor(Color("Black"))
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .center)
    }
    
    var loadingView: some View {
        ProgressView("Carregando...")
            .background {
                Color("Background")
                    .ignoresSafeArea()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var headerView: some View {
        HStack {
            Text("Encomendas")
                .font(.title.bold())
                .foregroundColor(Color("Black"))
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut) {
                    appViewModel.showNewTrackingView = true
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(Color("Black"))
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
            }

        }
        .padding()
    }
    
    var searchBarView: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(Color("Black"))
            
            // TODO: - Handle search
            TextField("Pesquisar", text: .constant(""))
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func customMenu() -> some View {
        HStack(spacing: 0) {
            ForEach(MenuType.allCases, id: \.self) { menu in
                Text(menu.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.currentMenu != menu ? Color("Black") : .white)
                    .padding(.vertical,8)
                    .frame(maxWidth: .infinity)
                    .background {
                        if viewModel.currentMenu == menu {
                            Capsule()
                                .fill(Color("Black"))
                                .shadow(color: Color("Black").opacity(0.1), radius: 5, x: 5, y: 5)
                                .matchedGeometryEffect(id: "MENU", in: animation)
                        }
                    }
                    .opacity(viewModel.trackings.count > 0 ? 1 : 0.6)
                    .onTapGesture {
                        if viewModel.trackings.count > 0 {
                            withAnimation(.easeInOut) { viewModel.currentMenu = menu }
                        }
                    }
            }
        }
        .background {
            Capsule()
                .fill(Color.white)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
}
