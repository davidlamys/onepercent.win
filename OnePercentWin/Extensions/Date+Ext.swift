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
    
    static func tomorrow() -> Date {
        return Calendar.gregorian.date(byAdding: Calendar.Component.day,
                                       value: 1,
                                       to: Date().startOfDay)!
    }
    
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
        return Calendar.gregorian.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.gregorian.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.gregorian.dateComponents([.year, .month], from: startOfDay)
        return Calendar.gregorian.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.gregorian.date(byAdding: components, to: startOfMonth)!
    }
    
    func allDates(till endDate: Date) -> [Date] {
        var date = self
        var array: [Date] = []
        while date <= endDate {
            array.append(date)
            date = Calendar.gregorian.date(byAdding: .day, value: 1, to: date)!
        }
        return array
    }
    
}

extension Calendar {
    static var gregorian: Calendar {
        return Calendar(identifier: .gregorian)
    }
}
