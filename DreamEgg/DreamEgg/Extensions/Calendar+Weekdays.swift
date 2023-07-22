//
//  Calendar+Weekdays.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import Foundation

extension Calendar {
    /**
     특정 날짜의 Interval 중 일치하는 Component에 따라 Date 배열을 리턴합니다.
     */
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
            
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
                
            guard date < dateInterval.end else {
                stop = true
                return
            }
                
            dates.append(date)
        }
            
        return dates
    }
    
    /**
     특정 날짜의 Interval 중 일치하는 Component에 따라 Date 배열을 리턴합니다.
     
     */
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents(
                [.hour, .minute, .second],
                from: dateInterval.start
            )
        )
    }
    
    public static func gmtCalendar() -> Self {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .gmt
        return cal
    }
}
