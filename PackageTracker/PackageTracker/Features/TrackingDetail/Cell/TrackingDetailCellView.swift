//
//  TrackingDetailCellView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 31/05/22.
//

import SwiftUI

extension View {
    func format(_ date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
}

struct TrackingDetailCellView: View {
    // MARK: - Properties
    var info: TrackInfo
    
    // MARK: - Layout
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if let date = try? Date(info.checkpointDate ?? "", strategy: .iso8601) {
                dateLabelView(date)
            }
            
            statusLabelView
            
            if let location = info.location,
               let index = location.lastIndex(of: " ") {
                
                HStack(spacing: 8) {
                    iconLocationView("pin.fill", color: Color("Black"))
                    locationLabelView(String(location.suffix(from: index)))
                }
                .padding(.bottom, 8)
            }
        }
        .padding(.leading, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.detailBackground)
        )
    }
}

// MARK: - Subviews
private extension TrackingDetailCellView {
    func dateLabelView(_ date: Date) -> some View {
        Text(format(date, dateStyle: .short, timeStyle: .medium))
            .font(.subheadline)
            .bold()
            .foregroundStyle(.primary)
            .fixedSize()
            .padding(.top, 8)
    }
    
    var statusLabelView: some View {
        Text(info.trackingDetail ?? "")
            .foregroundStyle(.primary)
            .font(.system(size: 16, weight: .bold, design: .default))
    }
    
    @ViewBuilder
    func locationLabelView(_ location: String) -> some View {
        Text(location)
            .font(.subheadline)
            .foregroundStyle(.primary)
    }
    
    @ViewBuilder
    func iconLocationView(_ systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.primary)
            .frame(width: 16, height: 16)
    }
}

// MARK: - Preview
#Preview {
    List {
        TrackingDetailCellView(info: .dummyData)
        TrackingDetailCellView(info: .dummyData)
        TrackingDetailCellView(info: .dummyData)
    }
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.dark)
}
