//
//  Date+Utilities.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/18.
//

import Foundation

extension Date {
    public static func isSameDate(lhs: Date, rhs: Date) -> Bool {
        lhs.year == rhs.year &&
        lhs.month == rhs.month &&
        lhs.day == rhs.day
    }
    
    public static var timeComponents: Set<Calendar.Component> = [.hour, .minute, .second, ]
    
    public static func - (lhs: Date, rhs: Date) -> DateComponents {
        return Calendar.getCurrentCalendar().dateComponents(timeComponents, from: rhs, to: lhs)
    }
    
    public static func -(lhs: Date, rhs: DateComponents) -> Date {
//        let year = rhs.year ?? 0
//        let month = rhs.month ?? 0
//        let day = rhs.day ?? 0
        let hour = rhs.hour ?? 0
        let minute = rhs.minute ?? 0
//        let second = rhs.second ?? 0
        
        let negative = DateComponents(hour: -hour, minute: -minute)
        return Calendar.getCurrentCalendar().date(byAdding: negative, to: lhs)! // yes force unwrap. sue me.
    }
    
    
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
    public var year: Int { return Calendar.getCurrentCalendar().component(.year, from: self) }
    /// Returns instance's month component
    public var month: Int { return Calendar.getCurrentCalendar().component(.month, from: self) }
    /// Returns instance's day component
    public var day: Int { return Calendar.getCurrentCalendar().component(.day, from: self) }
    /// Returns instance's hour component
    
    
    // MARK: HMS
    public var hour: Int { return Calendar.getCurrentCalendar().component(.hour, from: self) }
    /// Returns instance's minute component
    public var minute: Int { return Calendar.getCurrentCalendar().component(.minute, from: self) }
    /// Returns instance's second component
    public var second: Int { return Calendar.getCurrentCalendar().component(.second, from: self) }
}
