////
////  NewTrackingViewModelTests.swift
////  PackageTrackerTests
////
////  Created by Rogério Toledo on 05/06/22.
////
//
//import XCTest
//@testable import PackageTracker
//
//@MainActor
//class NewTrackingViewModelTests: XCTestCase {
//    // MARK: - Properties
//    private var viewModel: NewTrackingViewModel!
//    private var service: TrackingServiceProtocol!
//    
//    // MARK: - Setup
//    @MainActor override func setUp() {
//        super.setUp()
//        service = MockTrackingService()
//        viewModel = NewTrackingViewModel(service)
//    }
//    
//    // MARK: - Tests
//    func testSaveNewTrackingSuccessfully() async {
//        viewModel.packageName = Tracking.dummyData.title ?? ""
//        viewModel.trackingNumber = Tracking.dummyData.trackingNumber ?? ""
//        
//        XCTAssertNotNil(viewModel.packageName)
//        XCTAssertNotNil(viewModel.trackingNumber)
//        
//        await viewModel.saveNewTracking()
//        
//        XCTAssertFalse(viewModel.hasError)
//        XCTAssertEqual(viewModel.state, .success(tracking: Tracking.dummyData))
//    }
//    
//    func testSaveNewTrackingWithError() async {
//        service = MockTrackingService(mockTracking: nil)
//        viewModel = NewTrackingViewModel(service)
//        
//        viewModel.packageName = Tracking.dummyData.title ?? ""
//        viewModel.trackingNumber = Tracking.dummyData.trackingNumber ?? ""
//        
//        XCTAssertNotNil(viewModel.packageName)
//        XCTAssertNotNil(viewModel.trackingNumber)
//        
//        await viewModel.saveNewTracking()
//        
//        XCTAssertTrue(viewModel.hasError)
//        XCTAssertEqual(viewModel.state, .failed(error: TrackingServiceError.failed))
//    }
//}
