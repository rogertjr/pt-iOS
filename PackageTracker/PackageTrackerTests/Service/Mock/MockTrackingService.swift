////
////  MockTrackingService.swift
////  PackageTrackerTests
////
////  Created by Rogério Toledo on 05/06/22.
////
//
//import Foundation
//@testable import PackageTracker
//
//class MockTrackingService: TrackingServiceProtocol {
//    
//    let mockTracking: Tracking?
//    let mockTrackingList: [Tracking]?
//    
//    init(
//        mockTracking: Tracking? = Tracking.dummyData,
//        mockTrackingList: [Tracking]? = [Tracking.dummyData]
//    ) {
//        self.mockTracking = mockTracking
//        self.mockTrackingList = mockTrackingList
//    }
//    
//    func fetchTrackings() async throws -> [Tracking]? {
//        return mockTrackingList
//    }
//    
//    func fetchTracking(_ trackingNumber: String, carrier: Carrier) async throws -> Tracking? {
//        return mockTracking
//    }
//    
//    func saveNewTracking(_ model: Package) async throws -> Tracking {
//        guard let tracking = mockTracking else {
//            throw TrackingServiceError.failed
//        }
//        return tracking
//    }
//    
//    func deleteTracking(_ trackingNumber: String, carrier: Carrier) async throws -> Tracking {
//        guard let tracking = mockTracking else {
//            throw TrackingServiceError.failed
//        }
//        return tracking
//    }
//}
