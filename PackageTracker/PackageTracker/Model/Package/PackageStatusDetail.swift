//
//  PackageStatusDetail.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 31/05/22.
//

import SwiftUI

struct PackageStatusDetail: Identifiable {
    var id: String = UUID().uuidString
    let date: String
    let status: String
    let lastLocation: String?
    let nextLocation: String?
}

extension PackageStatusDetail {
    static let dummyData: [PackageStatusDetail] = [
        PackageStatusDetail(date: "31/05/2022 às 13:20",
                            status: "Objeto saiu para entrega ao destinatário",
                            lastLocation: "CDD SAO PAULO - Sao Paulo/SP",
                            nextLocation: nil),
        PackageStatusDetail(date: "31/05/2022 às 11:20",
                            status: "Objeto em trânsito - por favor aguade",
                            lastLocation: "CTE SAO PAULO - Sao Paulo/SP",
                            nextLocation: "CDD SAO PAULO - Sao Paulo/SP"),
        PackageStatusDetail(date: "31/05/2022 às 08:20",
                            status: "Objeto em trânsito - por favor aguade",
                            lastLocation: "AGF SANTA CRUZ - Sao Paulo/SP",
                            nextLocation: "CTCE SAO PAULO - Sao Paulo/SP"),
        PackageStatusDetail(date: "31/05/2022 às 06:20",
                            status: "Objeto psotado",
                            lastLocation: "AGF SANTA CRUZ - Sao Paulo/SP",
                            nextLocation: nil)
    ]
}
