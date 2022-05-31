//
//  PackageListView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI

struct PackageListView: View {
    // MARK: - Properties
    @StateObject var viewModel = PackageListViewModel()
    var animation: Namespace.ID
    
    // MARK: - Layout
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                headerView
                searchBarView
                customMenu()
                packageListView()
            }
        }
        .background {
            Color("Background")
                .ignoresSafeArea()
        }
    }
}

// MARK: - Subviews
private extension PackageListView {
    var headerView: some View {
        HStack {
            Text("Encomendas")
                .font(.title.bold())
                .foregroundColor(Color("Black"))
            
            Spacer()
            
            Button {
                // TODO: CREATE ACTION
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
                    .onTapGesture {
                        withAnimation(.easeInOut) { viewModel.currentMenu = menu }
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
    
    @ViewBuilder
    func packageListView() -> some View {
        PackageCellView()
        PackageCellView()
        PackageCellView()
        PackageCellView()
    }
}
