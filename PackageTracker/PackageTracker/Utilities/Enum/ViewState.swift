//
//  Status.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 31/05/24.
//

import Foundation

enum ViewState: Equatable {
	case idle
	case loading
	case success
	case failed(error: Error)
	case finishedLoading
	
	static func == (lhs: ViewState, rhs: ViewState) -> Bool {
		switch (lhs, rhs) {
		case (.idle, .idle),
			(.loading, .loading),
			(.success, .success),
			(.failed, .failed),
			(.finishedLoading, .finishedLoading):
			return true
		default:
			return false
		}
	}
}
