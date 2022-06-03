//
//  Checkpoint.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

struct Checkpoint: Identifiable, Decodable {
    var id: String? = UUID().uuidString
    var location: String?
    var message: String?
    var tag: String?
    var checkpointTime: String?
//    var coordinates: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case location
        case message
        case tag
        case checkpointTime = "checkpoint_time"
//        case coordinates
    }
}

extension Checkpoint {
    static let dummyData: Checkpoint = Checkpoint(id: UUID().uuidString,
                                                  location: "Agência dos Correios, DIADEMA - SP",
                                                  message: "Objeto postado após o horário limite da unidade",
                                                  tag: "InTransit",
                                                  checkpointTime: "2022-06-01T18:38:00")
}
