//
//  Date+StartDates.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import Foundation

extension Date {
    /**
     인스턴스의 월에서 첫번째 날을 리턴합니다.
     */
    func startDayOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: self
            )
        ) ?? self
    }
    
    func lastDayOfMonth(using calendar: Calendar) -> Date {
            return calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: self.startDayOfMonth(using: calendar)
            )!
        }
    
    /**
     Date instance가 갖는 시간과 분을 리턴합니다.
     */
    func startOfDayTime(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents(
                [.hour, .minute],
                from: self
            )
        ) ?? self
    }
    
    func weekOfMonth(using calendar: Calendar) -> Int {
        calendar.component(.weekOfMonth, from: self)
    }
}


