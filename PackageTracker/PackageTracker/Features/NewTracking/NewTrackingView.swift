//
//  NewTrackingView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 02/06/22.
//

import SwiftUI
import SwiftData

struct NewTrackingView: View {
    // MARK: - Properties
    @EnvironmentObject var viewModel: TrackingListViewModel
    @Environment(\.colorScheme) var scheme
	@Environment(\.dismiss) private var dismiss
    
    // MARK: - Layout
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack(spacing: 8) {
                    trackingFieldView
                    packageNameFieldView
                }
                .frame(maxHeight: .infinity,alignment: .center)
                
                Spacer()
                saveButtonView
                    .padding(.bottom, 16)
            }
            .blur(radius: viewModel.isLoading ? 25 : 0)

			if viewModel.isLoading {
				ProgressView {
					Label("Loading...", systemImage: "")
				}
			}
        }
        .padding(.horizontal, 16)
        .navigationTitle("Add")
		.alert(isPresented: $viewModel.hasError) {
			Alert(title: Text("Oops!"),
				  message: Text("Something went wrong."),
				  primaryButton: .destructive(Text("Cancel"), action: { }),
				  secondaryButton: .default(Text("Try Again"), action: {
				Task {
					await viewModel.createTracking()
				}
			}))
		}
    }
}

// MARK: - Subviews
private extension NewTrackingView {
    var trackingFieldView: some View {
        Label {
            TextField("Tracking Code", text: $viewModel.trackingNumber)
                .padding(.leading, 10)
                .autocorrectionDisabled()
                .textCase(.uppercase)
        } icon: {
            Image(systemName: "barcode.viewfinder")
                .font(.title3)
                .tint(.primary)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(scheme == .dark ? .detailBackground : .cardBackground)
        }
    }
    
    var packageNameFieldView: some View {
        Label {
            TextField("Title", text: $viewModel.packageName)
                .padding(.leading ,10)
                .autocorrectionDisabled()
        } icon: {
            Image(systemName: "shippingbox.fill")
                .font(.title3)
                .tint(.primary)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 15)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(scheme == .dark ? .detailBackground : .cardBackground)
        }
    }
    
    var saveButtonView: some View {
        Button(action: {
            Task {
                await viewModel.createTracking()
             
                switch viewModel.state {
                case .success:
                    if !viewModel.hasError {
                        dismiss()
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
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(scheme == .dark ? .white : .black)
                }
                .foregroundStyle(scheme == .dark ? .black : .white)
                .padding(.bottom, 10)
        }
        .disabled(!viewModel.isAbleToContinue)
        .opacity(viewModel.isAbleToContinue ? 1 : 0.6)
    }
}

// MARK: - Preview
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TrackingData.self, configurations: config)
        
        let viewModel = TrackingListViewModel(TrackingService(), modelContext: container.mainContext)
        return NavigationStack {
            NewTrackingView()
                .environmentObject(viewModel)
        }
        .preferredColorScheme(.dark)
    } catch {
        fatalError("Failed to build container")
    }
}
