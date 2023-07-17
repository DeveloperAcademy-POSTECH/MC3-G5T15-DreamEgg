//
//  Date+StartDates.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import Foundation

extension Date {
    /**
     Date instance가 포함된 이번 달, 이번 년도를 리턴합니다.
     */
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: self
            )
        ) ?? self
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


