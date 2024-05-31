//
//  AnimatePlaceholderModifier.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/24.
//

import SwiftUI


extension View {
	func animatePlaceholder(isLoading: Binding<Bool>) -> some View {
		modifier(AnimatePlaceholderModifier(isLoading: isLoading))
	}
}

struct AnimatePlaceholderModifier: AnimatableModifier {
	// MARK: - Properties
	@Binding var isLoading: Bool
	@State private var isAnimating: Bool = false
	private var center = (UIScreen.main.bounds.width / 2) + 110
	private let animation: Animation = .linear(duration: 2)
	
	// MARK: - Init
	init(isLoading: Binding<Bool>) {
		self._isLoading = isLoading
	}
	
	// MARK: - Views
	func body(content: Content) -> some View {
		content.overlay(animView.mask(content))
	}
	
	var animView: some View {
		ZStack {
			Color.black.opacity(isLoading ? 0.09 : 0.0)
			Color.white.mask(
				Rectangle()
					.fill(
						LinearGradient(gradient: .init(colors: [.clear, .white.opacity(0.48), .clear]),
									   startPoint: .top ,
									   endPoint: .bottom)
					)
					.scaleEffect(1.5)
					.rotationEffect(.init(degrees: 70.0))
					.offset(x: isAnimating ? center : -center)
			)
		}
		.animation(isLoading ? animation.repeatForever(autoreverses: false) : nil, value: isAnimating)
		.onAppear {
			guard isLoading else { return }
			isAnimating.toggle()
		}
		.onChange(of: isLoading) { _, _ in
			isAnimating.toggle()
		}
	}
}

