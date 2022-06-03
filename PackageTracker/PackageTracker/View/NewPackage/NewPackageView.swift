//
//  NewPackageView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 02/06/22.
//

import SwiftUI

struct NewPackageView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: NewPackageViewModel = NewPackageViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    
    // MARK: - Layout
    var body: some View {
        VStack {
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
        .padding()
        .background {
            Color("Background")
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Subviews
private extension NewPackageView {
    var backButtonView: some View {
        Button {
            withAnimation(.easeInOut.delay(0.07)) {
                appViewModel.showNewPackageView = false
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
                      text: $viewModel.tracking)
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
            viewModel.saveNewPackage()
            withAnimation(.easeInOut.delay(0.07)) {
                appViewModel.showNewPackageView = false
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

