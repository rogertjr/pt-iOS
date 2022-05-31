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
            Text(statusDetail.date)
                .font(.caption2)
                .bold()
                .foregroundColor(.gray)
                .fixedSize()
                .padding(.top, 8)
            
            Group {
                Text(statusDetail.status)
                    .foregroundColor(Color("Black"))
                    .font(.system(size: 16,
                                  weight: .bold,
                                  design: .default))
                
                HStack(spacing: 10) {
                    Image(systemName: "pin.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("Black"))
                        .frame(width: 16, height: 16)
                    
                    Text(statusDetail.lastLocation ?? "")
                        .font(.system(size: 14,
                                      weight: .regular,
                                      design: .default))
                        .foregroundColor(Color("Black"))
                }
                
                if let nextLocation = statusDetail.nextLocation {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.forward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color("Black"))
                            .frame(width: 16, height: 16)
                        
                        Text(nextLocation)
                            .font(.system(size: 14,
                                          weight: .regular,
                                          design: .default))
                            .foregroundColor(Color("Black"))
                    }
                }
            }
            .padding(.leading, 10)
        }
    }
}

// MARK: - Subvies
private extension PackageDetailCellView {
    
}

// MARK: - PreviewProvider
struct PackageDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        PackageDetailCellView(statusDetail: PackageStatusDetail.dummyData.first!)
            .previewLayout(.sizeThatFits)
    }
}
