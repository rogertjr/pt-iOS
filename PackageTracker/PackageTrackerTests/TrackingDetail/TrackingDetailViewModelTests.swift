////
////  TrackingDetailViewModelTests.swift
////  PackageTrackerTests
////
////  Created by Rogério Toledo on 05/06/22.
////
//
//import XCTest
//@testable import PackageTracker
//
//@MainActor
//class TrackingDetailViewModelTests: XCTestCase {
//    
//    // MARK: - Properties
//    private var viewModel: TrackingDetailViewModel!
//    private var service: TrackingServiceProtocol!
//    
//    // MARK: - Setup
//    @MainActor override func setUp() {
//        super.setUp()
//        service = MockTrackingService()
//        viewModel = TrackingDetailViewModel(service)
//    }
//    
//    // MARK: - Tests
//    func testDeleteTrackingSuccessfully() async {
//        let trackingNumber = Tracking.dummyData.trackingNumber ?? ""
//        
//        XCTAssertNotNil(trackingNumber)
//        
//        await viewModel.deleteTracking(trackingNumber)
//        
//        XCTAssertEqual(viewModel.state, .success(tracking: Tracking.dummyData))
//        XCTAssertFalse(viewModel.hasError)
//    }
//}
