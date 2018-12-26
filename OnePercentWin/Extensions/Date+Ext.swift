//
//  Date+Ext.swift
//  OnePercentWin
//
//  Created by David on 27/12/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

extension Date {
    var prettyDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yy"
        return dateFormatter.string(from: self)
    }
    
    var historyCellModelDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "(d MMMM yyyy)"
        return dateFormatter.string(from: self)
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    func allDates(till endDate: Date) -> [Date] {
        var date = self
        var array: [Date] = []
        while date <= endDate {
            array.append(date)
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        return array
    }
    
}
