//
//  DECalendarTestView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import SwiftUI

struct DECalendarTestView: View {
    private var calendar: Calendar
    private let monthDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    @State private var selectedDate: Date = Date.now
    
    var body: some View {
        VStack {
            DECalendar(
                style: .week,
                calendar: calendar,
                date: $selectedDate
            ) { date in
                Button {
                    selectedDate = date
                } label: {
                    VStack(spacing: 12) {
                        Text(weekDayFormatter.string(from: date))
                        
                        Text(dayFormatter.string(from: date))
                    }
                    .font(.dosIyagiBold(.body))
                    .foregroundStyle(calendar.isDate(date, inSameDayAs: selectedDate) ? .primary : .secondary)
                    .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                    .frame(maxWidth: 45, maxHeight: 75)
                    .background {
                        if calendar.isDate(
                            date,
                            inSameDayAs: selectedDate
                        ) {
                            Capsule()
                                .fill(Color.dreamPurple)
                        }
                    }
                }
            } monthHeader: { eachWeeksDays in
                let firstDayInWeek = eachNthWeekFirstDay(eachWeeksDays)
                let lastDayInWeek = eachNthWeekLastDay(eachWeeksDays)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(monthDayFormatter.string(from: selectedDate))월")
                        .font(.dosIyagiBold(.title))
                    
                    HStack(spacing: -4) {
                        Text("\(selectedDate.weekOfMonth(using: calendar))주차")
                        
                        Text(" (\(monthDayFormatter.string(from: selectedDate)).\(dayFormatter.string(from: firstDayInWeek)).")
                            .kerning(-0.75)
                        
                        Text(" ~ ")
                            .baselineOffset(-6)
                            
                        
                        Text("\(monthDayFormatter.string(from: selectedDate)).\(dayFormatter.string(from: lastDayInWeek)).)")
                            .kerning(-0.75)
                    }
                    .font(.dosIyagiBold(.callout))
                   
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding()
                
            } weekSwitcher: {
                Button {
                    guard let newDate = calendar.date(
                        byAdding: .weekOfMonth,
                        value: -1,
                        to: selectedDate
                    ) else {
                        return
                    }
                    
                    selectedDate = newDate
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(.horizontal)
                        .tint(.subButtonBlue)
                }
                Button {
                    guard let newDate = calendar.date(
                        byAdding: .weekOfMonth,
                        value: 1,
                        to: selectedDate
                    ) else {
                        return
                    }
                    
                    selectedDate = newDate
                } label: {
                    Image(systemName: "chevron.right")
                        .padding(.horizontal)
                        .tint(.subButtonBlue)
                }
            }
        }
        
    }
    
    // MARK: LifeCycle
    init(calendar: Calendar = .init(identifier: .gregorian)) {
        var temp = calendar
        temp.timeZone = .gmt
        self.calendar = temp
        self.monthDayFormatter = DateFormatter(dateFormat: "M", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
        self.timeFormatter = DateFormatter(dateFormat: "H:mm", calendar: calendar)
    }
    
    // MARK: Methods
    private func eachNthWeekFirstDay(_ dates: [Date]) -> Date {
        if Date.isSameMonth(in: calendar, selectedDate, dates.first!) {
            return dates.first!
        } else {
            return selectedDate.startDayOfMonth(using: calendar)
        }
    }
    
    private func eachNthWeekLastDay(_ dates: [Date]) -> Date {
        if Date.isSameMonth(in: calendar, selectedDate, dates.last!) {
            return dates.last!
        } else {
            return selectedDate.lastDayOfMonth(using: calendar)
        }
    }
}

struct DECalendarTestView_Previews: PreviewProvider {
    static var previews: some View {
        DECalendarTestView()
    }
}
