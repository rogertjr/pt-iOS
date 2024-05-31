//
//  LoadingView.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import SwiftUI

struct LoadingView: View {
    // MARK: - Properties
    var backgroundColor: Color
    var foregroundColor: Color
    var title: String
    
    // MARK: - Layout
    var body: some View {
        ProgressView(title)
            .foregroundColor(foregroundColor)
            .background {
                backgroundColor
                    .ignoresSafeArea()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(backgroundColor: Color("black"),
                    foregroundColor: .white,
                    title: "Carregando...")
            .previewLayout(.sizeThatFits)
    }
}
