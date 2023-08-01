//
//  DateComponent+Utilities.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/28.
//

import Foundation

extension DateComponents {
    /// Returns components populated by n years
    public static func years(_ count: Int) -> DateComponents { return DateComponents(year: count) }
    /// Returns components populated by n months
    public static func months(_ count: Int) -> DateComponents { return DateComponents(month: count) }
    /// Returns components populated by n days
    public static func days(_ count: Int) -> DateComponents { return DateComponents(day: count) }
    /// Returns components populated by n hours
    public static func hours(_ count: Int) -> DateComponents { return DateComponents(hour: count) }
    /// Returns components populated by n minutes
    public static func minutes(_ count: Int) -> DateComponents { return DateComponents(minute: count) }
    /// Returns components populated by n seconds
    public static func seconds(_ count: Int) -> DateComponents { return DateComponents(second: count) }
    /// Returns components populated by n nanoseconds
    public static func nanoseconds(_ count: Int) -> DateComponents { return DateComponents(nanosecond: count) }
}
