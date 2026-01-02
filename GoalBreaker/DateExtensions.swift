//
//  DateExtensions.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import Foundation

extension Date {
    /// Returns the week of year for the date
    var weekOfYear: Int {
        Calendar.current.component(.weekOfYear, from: self)
    }
    
    /// Returns the start of the week (Monday) for the date
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// Calculates the number of months between two dates
    func monthDiff(from date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date, to: self)
        return abs(components.month ?? 0)
    }
    
    /// Returns the start of the month for the date
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// Checks if the date is in the current week
    var isInCurrentWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
}
