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
}
