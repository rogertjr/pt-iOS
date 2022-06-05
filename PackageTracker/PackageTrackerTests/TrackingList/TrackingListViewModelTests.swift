//
//  TrackingListViewModelTests.swift
//  PackageTrackerTests
//
//  Created by Rogério Toledo on 05/06/22.
//

import XCTest
@testable import PackageTracker

@MainActor
class TrackingListViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var viewModel: TrackingListViewModel!
    private var service: TrackingServiceProtocol!
    
    // MARK: - Setup
    @MainActor override func setUp() {
        super.setUp()
        service = MockTrackingService()
        viewModel = TrackingListViewModel(service)
    }
    
    // MARK: - Tests
    func testFetchTrackingListSuccessfully() async throws {
        await viewModel.fetchTrackings()
        
        XCTAssertEqual(viewModel.trackings.count, 1)
        XCTAssertFalse(viewModel.hasError)
        XCTAssertEqual(viewModel.state, .success)
    }
    
    func testFetchEmptyTrackingList() async throws {
        service = MockTrackingService(mockTrackingList: nil)
        viewModel = TrackingListViewModel(service)
        
        await viewModel.fetchTrackings()
        XCTAssertTrue(viewModel.hasError)
        XCTAssertEqual(viewModel.trackings.count, 0)
    }
    
    func testFetchTrackingListWithError() async throws {
        service = MockTrackingService(mockTrackingList: nil)
        viewModel = TrackingListViewModel(service)
        
        await viewModel.fetchTrackings()
        
        XCTAssertEqual(viewModel.trackings.count, 0)
        XCTAssertTrue(viewModel.hasError)
        XCTAssertEqual(viewModel.state, .failed(error: TrackingServiceError.failed))
    }
    
    func testFetchTrackingDetailSuccessfully() async throws {
        let tracking = Tracking.dummyData
        
        await viewModel.fetchTrackingDetails(tracking)
        
        XCTAssertNotNil(viewModel.selectedTracking)
        XCTAssertFalse(viewModel.hasError)
        XCTAssertEqual(viewModel.state, .success)
    }
    
    func testFetchTrackingDetailWithError() async throws {
        let tracking = Tracking.dummyData
        service = MockTrackingService(mockTracking: nil)
        viewModel = TrackingListViewModel(service)
        
        await viewModel.fetchTrackingDetails(tracking)
        
        XCTAssertNil(viewModel.selectedTracking)
        XCTAssertTrue(viewModel.hasError)
        XCTAssertEqual(viewModel.state, .failed(error: TrackingServiceError.failed))
    }
}
