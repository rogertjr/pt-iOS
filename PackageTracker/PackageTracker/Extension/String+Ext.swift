//
//  String+Ext.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

extension String {
    /// Converst date in a string from "2022-06-01T18:38:00" to "01/06/22 às 6:38 PM"
    func dateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: self)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.locale = Locale.current
        convertDateFormatter.dateFormat = "dd/MM/yy 'às' h:mm a"

        guard let date = date else { return ""}
        return convertDateFormatter.string(from: date)
    }
}
