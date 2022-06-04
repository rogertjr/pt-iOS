//
//  NewTrackingView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 02/06/22.
//

import SwiftUI

struct NewTrackingView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: NewTrackingViewModel = NewTrackingViewModel(TrackingService())
    @EnvironmentObject var trackingListViewModel: TrackingListViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    // MARK: - Layout
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                loadingView
            default:
                ZStack {
                    HStack {
                        backButtonView
                        Spacer()
                    }
                    
                    headerLabelView
                }
                
                VStack(spacing: 8) {
                    trackingFieldView
                    packageNameFieldView
                }
                .frame(maxHeight: .infinity,alignment: .center)
                
                saveButtonView
            }
        }
        .padding()
        .background {
            Color("Background")
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Erro", isPresented: $viewModel.hasError, presenting: viewModel.state) { detail in
            Button("Tentar novamente") {
                Task {
                    await viewModel.saveNewTracking()
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
private extension NewTrackingView {
    var loadingView: some View {
        ProgressView("Carregando...")
            .background {
                Color("Background")
                    .ignoresSafeArea()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var backButtonView: some View {
        Button {
            withAnimation(.easeInOut.delay(0.07)) {
                appViewModel.showNewTrackingView = false
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
    }
    
    var headerLabelView: some View {
        Text("Nova encomenda")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    var trackingFieldView: some View {
        Label {
            TextField("Código de rastreio",
                      text: $viewModel.trackingNumber)
                .padding(.leading ,10)
        } icon: {
            Image(systemName: "barcode.viewfinder")
                .font(.title3)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white)
        }
    }
    
    var packageNameFieldView: some View {
        Label {
            TextField("Nome da encomenda",
                      text: $viewModel.packageName)
                .padding(.leading ,10)
        } icon: {
            Image(systemName: "shippingbox.fill")
                .font(.title3)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white)
        }
    }
    
    var saveButtonView: some View {
        Button(action: {
            Task {
                await viewModel.saveNewTracking()
             
                switch viewModel.state {
                case let .success(tracking):
                    withAnimation(.easeInOut.delay(0.07)) {
                        trackingListViewModel.trackings.append(tracking)
                        appViewModel.showNewTrackingView = false
                    }
                default:
                    return
                }
            }
        }) {
            Text("Salvar")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12,
                                     style: .continuous)
                        .fill(Color("Black"))
                }
                .foregroundColor(.white)
                .padding(.bottom, 10)
        }
        .disabled(!viewModel.isAbleToContinue)
        .opacity(viewModel.isAbleToContinue ? 1 : 0.6)
    }
}

// MARK: - Preview
struct NewTrackingView_PrewViews: PreviewProvider {
    static var previews: some View {
        NewTrackingView()
            .environmentObject(AppViewModel())
    }
}
