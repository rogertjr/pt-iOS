//
//  Transition+Ext.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 05/06/22.
//

import SwiftUI

extension AnyTransition {
    static var pushTransition: AnyTransition {
            AnyTransition.asymmetric(insertion: .move(edge: .trailing),
                                     removal: .move(edge: .trailing))
        
    }
}
