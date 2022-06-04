//
//  TrackingCellView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import SwiftUI

struct TrackingCellView: View {
    // MARK: - Properties
    @EnvironmentObject var trackingListViewModel: TrackingListViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    var tracking: Tracking
    
    // MARK: - Layout
    var body: some View {
        HStack(spacing: 12) {
            mapView
            VStack(alignment: .leading, spacing: 10) {
                cardHeaderView
                if let lastMessage = tracking.subtagMessage {
                    lastStatusView(lastMessage)
                }
                detailButtonView
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .topLeading)
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 20,
                             style: .continuous)
                .fill(.white)
                .shadow(color: Color("Black").opacity(0.08),
                        radius: 5, x: 5, y: 5)
        }
        .padding([.leading, .trailing])
    }
}

// MARK: - Subviews
private extension TrackingCellView {
    var mapView: some View {
        Group {
            Image(systemName: "map")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
        }
        .frame(width: 100)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color("Black"))
        }
    }
    
    var cardHeaderView: some View {
        Group {
            Text(tracking.title ?? "")
                .fontWeight(.bold)
                .foregroundColor(Color("Black"))
            
            Text(tracking.trackingNumber ?? "")
                .font(.caption2.bold())
                .foregroundColor(.gray)
                .padding(.top, -5)
        }
    }
    
    @ViewBuilder
    func lastStatusView(_ status: String) -> some View {
        Text(status)
            .font(.system(size: 14))
            .foregroundColor(Color("Black").opacity(0.8))
    }
    
    var detailButtonView: some View {
        HStack {
            Spacer()
            
            Button {
                Task {
                    await trackingListViewModel.fetchTrackingDetails(tracking)
                    switch trackingListViewModel.state {
                    case .success:
                        withAnimation(.easeInOut) {
                            appViewModel.showTrackingDetailView = true
                        }
                    default:
                        return
                    }
                }
            } label: {
                Text("Ver detalhes")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background {
                        Capsule()
                            .fill(Color("Black"))
                    }
            }
            .scaleEffect(0.9)
            
            Spacer()
        }
        .offset(y: 10)
    }
}
