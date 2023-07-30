//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Жансая Шакуали on 30.07.2023.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
