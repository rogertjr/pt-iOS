//
//  DeferredViewModifier.swift
//  PackageTracker
//
//  Created by Rogério do Carmo Toledo Júnior on 31/05/24.
//

import SwiftUI

extension View {
    func deferredRendering(for seconds: Double) -> some View {
        modifier(DeferredViewModifier(threshold: seconds))
    }
}

// A ViewModifier that defers its rendering until after the provided threshold surpasses
struct DeferredViewModifier: ViewModifier {
    // MARK: - Properties
    let threshold: Double
    @State private var shouldRender = false

    // MARK: - ViewModifier
    func body(content: Content) -> some View {
        _content(content)
            .onAppear {
               DispatchQueue.main.asyncAfter(deadline: .now() + threshold) {
                   self.shouldRender = true
               }
            }
    }

    // MARK: - Builder
    @ViewBuilder private func _content(_ content: Content) -> some View {
        if shouldRender {
            content
        } else {
            content
                .hidden()
        }
    }
}
