//
//  TrackingCardView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/24.
//

import SwiftUI

struct TrackingCardView: View {
	// MARK: - Properties
	@Environment(\.colorScheme) var scheme
	var backgroundColor: Color {
		scheme == .dark
		? .detailBackground
		: Color(UIColor.systemGroupedBackground)
	}
	
	var tracking: Tracking
	@Binding var isLoading: Bool
	
	// MARK: - UI Elements
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
		.redacted(reason: isLoading ? .placeholder : [])
		.animatePlaceholder(isLoading: $isLoading)
		.padding(10)
		.background {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(backgroundColor)
		}
		.padding([.leading, .trailing])
	}
}

// MARK: - Builders
private extension TrackingCardView {
	var mapView: some View {
		Group {
			Image(systemName: "map")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.foregroundStyle(.white)
		}
		.frame(width: 100)
		.padding()
		.background {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(Color(.itemBackground))
		}
	}
	
	var cardHeaderView: some View {
		Group {
			Text(tracking.title ?? "")
				.bold()
				.foregroundStyle(.primary)
			
			Text(tracking.trackingNumber ?? "")
				.font(.caption2.bold())
				.foregroundStyle(.primary)
		}
	}
	
	@ViewBuilder
	func lastStatusView(_ status: String) -> some View {
		Text(status)
			.font(.system(size: 14))
			.foregroundStyle(.primary)
	}
	
	var detailButtonView: some View {
		HStack {
			Button { } label: {
				Text("See details")
					.font(.callout)
					.fontWeight(.semibold)
					.padding(.vertical, 8)
					.padding(.horizontal, 20)
					.background {
						Capsule()
							.fill(.itemBackground)
					}
			}
			.tint(.primary)
			
			Spacer()
		}
	}
}

// MARK: - Preview
#Preview {
	return NavigationStack {
		VStack {
			TrackingCardView(tracking: Tracking.dummyData,
							 isLoading: .constant(true))
			.frame(height: 150)
			
			TrackingCardView(tracking: Tracking.dummyData,
							 isLoading: .constant(false))
			.frame(height: 150)
		}
	}
	.preferredColorScheme(.dark)
}
