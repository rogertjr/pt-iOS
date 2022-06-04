//
//  TrackingDetailCellView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 31/05/22.
//

import SwiftUI

struct TrackingDetailCellView: View {
    // MARK: - Properties
    var checkpoint: Checkpoint
    
    // MARK: - Layout
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            dateLabelView
            statusLabelView
            
            HStack(spacing: 8) {
                iconLocationView("pin.fill", color: Color("Black"))
                locationLabelView(checkpoint.location ?? "")
            }
            .padding(.bottom, 8)
        }
        .padding(.leading, 10)
    }
}

// MARK: - Subviews
private extension TrackingDetailCellView {
    var dateLabelView: some View {
        Text(checkpoint.checkpointTime?.dateFormatted() ?? "")
            .font(.caption2)
            .bold()
            .foregroundColor(.gray)
            .fixedSize()
            .padding(.top, 8)
    }
    
    var statusLabelView: some View {
        Text(checkpoint.message ?? "")
            .foregroundColor(Color("Black"))
            .font(.system(size: 16,
                          weight: .bold,
                          design: .default))
    }
    
    @ViewBuilder
    func locationLabelView(_ location: String) -> some View {
        Text(location)
            .font(.system(size: 14,
                          weight: .regular,
                          design: .default))
            .foregroundColor(Color("Black"))
    }
    
    @ViewBuilder
    func iconLocationView(_ systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .frame(width: 16, height: 16)
    }
}

// MARK: - PreviewProvider
struct TrackingDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingDetailCellView(checkpoint: Checkpoint.dummyData)
            .previewLayout(.sizeThatFits)
    }
}
