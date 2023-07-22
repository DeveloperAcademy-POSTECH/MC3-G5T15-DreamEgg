//
//  Date+Utilities.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/18.
//

import Foundation

extension Date {
    public static var allComponents: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .nanosecond, .calendar, .timeZone]

    public func allComponents(in calendar: Calendar) -> DateComponents {
        return calendar.dateComponents(Date.allComponents, from: self)
    }

    public static func isSameMonth(in calendar: Calendar, _ date1: Date, _ date2: Date) -> Bool {
        return (date1.allComponents(in: calendar).year == date2.allComponents(in: calendar).year) &&
        (date1.allComponents(in: calendar).month == date2.allComponents(in: calendar).month)
    }
    
    // MARK: YMD
    /// Returns instance's year component
    public var year: Int { return Calendar.gmtCalendar().component(.year, from: self) }
    /// Returns instance's month component
    public var month: Int { return Calendar.gmtCalendar().component(.month, from: self) }
    /// Returns instance's day component
    public var day: Int { return Calendar.gmtCalendar().component(.day, from: self) }
    /// Returns instance's hour component
    
    
    // MARK: HMS
    public var hour: Int { return Calendar.gmtCalendar().component(.hour, from: self) }
    /// Returns instance's minute component
    public var minute: Int { return Calendar.gmtCalendar().component(.minute, from: self) }
    /// Returns instance's second component
    public var second: Int { return Calendar.gmtCalendar().component(.second, from: self) }
}
