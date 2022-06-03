//
//  PackageDetailCellView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 31/05/22.
//

import SwiftUI

struct PackageDetailCellView: View {
    // MARK: - Properties
    var statusDetail: PackageStatusDetail
    
    // MARK: - Layout
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            dateLabelView
            
            Group {
                statusLabelView
                iconLocationView("pin.fill")
                locationLabelView(statusDetail.lastLocation ?? "")
            }
                
            if let nextLocation = statusDetail.nextLocation {
                HStack(spacing: 10) {
                    iconLocationView("arrow.forward")
                    locationLabelView(nextLocation)
                }
            }
        }
        .padding(.leading, 10)
    }
}

// MARK: - Subvies
private extension PackageDetailCellView {
    var dateLabelView: some View {
        Text(statusDetail.date)
            .font(.caption2)
            .bold()
            .foregroundColor(.gray)
            .fixedSize()
            .padding(.top, 8)
    }
    
    var statusLabelView: some View {
        Text(statusDetail.status)
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
    func iconLocationView(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color("Black"))
            .frame(width: 16, height: 16)
    }
}

// MARK: - PreviewProvider
struct PackageDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        PackageDetailCellView(statusDetail: PackageStatusDetail.dummyData.first!)
            .previewLayout(.sizeThatFits)
    }
}
