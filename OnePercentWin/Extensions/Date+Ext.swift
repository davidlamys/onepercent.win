//
//  Date+Ext.swift
//  OnePercentWin
//
//  Created by David on 27/12/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

extension Date {
    private static let prettyDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yy"
        return dateFormatter
    }()
    
    private static let historyCellModelDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "(d MMMM yyyy)"
        return dateFormatter
    }()
    
    private static let monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter
    }()
    
    private static let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    private static let dayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter
    }()
    
    var prettyDate: String {
        return Date.prettyDateFormatter.string(from: self)
    }
    
    var dayString: String {
        return Date.dayFormatter.string(from: self)
    }
    
    var dateString: String {
        return Date.dateFormatter.string(from: self)
    }
    
    var monthString: String {
        return Date.monthFormatter.string(from: self)
    }
    
    var historyCellModelDate: String {
        return Date.historyCellModelDateFormatter.string(from: self)
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
