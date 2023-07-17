//
//  DECalendarTestView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import SwiftUI

struct DECalendarTestView: View {
    private let calendar: Calendar
    private let monthDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    @State private var selectedDate = Self.now
    private static var now = Date() // Cache now
    
    var body: some View {
        DECalendar(
            style: .week,
            calendar: calendar,
            date: $selectedDate
        ) { date in
            Button {
                selectedDate = date
            } label: {
                VStack(spacing: 15) {
                    Text(weekDayFormatter.string(from: date))
                        .font(.dosIyagiBold(.body))
                    
                    Text(dayFormatter.string(from: date))
                        .font(.dosIyagiBold(.body))
                        .fontWeight(.semibold)
                }
                .foregroundStyle(calendar.isDate(date, inSameDayAs: selectedDate) ? .primary : .secondary)
                .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                .frame(maxWidth: 45, maxHeight: 80)
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
        } monthHeader: {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(monthDayFormatter.string(from: selectedDate))월")
                    .font(.dosIyagiBold(.title))
                    
                Text("\(selectedDate.weekOfMonth(using: calendar))주차")
                    .font(.dosIyagiBold(.callout))
                
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding()
            
        } weekSwitcher: {
            Button {
                withAnimation(.easeIn) {
                    guard let newDate = calendar.date(
                        byAdding: .weekOfMonth,
                        value: -1,
                        to: selectedDate
                    ) else {
                        return
                    }
                    
                    selectedDate = newDate
                }
            } label: {
                Image(systemName: "chevron.left")
                    .padding(.horizontal)
            }
            Button {
                withAnimation(.easeIn) {
                    guard let newDate = calendar.date(
                        byAdding: .weekOfMonth,
                        value: 1,
                        to: selectedDate
                    ) else {
                        return
                    }
                    
                    selectedDate = newDate
                }
            } label: {
                Image(systemName: "chevron.right")
                    .padding(.horizontal)
            }
        }
    }
    
    // MARK: LifeCycle
    init(calendar: Calendar = .init(identifier: .gregorian)) {
        self.calendar = calendar
        self.monthDayFormatter = DateFormatter(dateFormat: "MM", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
        self.timeFormatter = DateFormatter(dateFormat: "H:mm", calendar: calendar)
    }
}

struct DECalendarTestView_Previews: PreviewProvider {
    static var previews: some View {
        DECalendarTestView()
    }
}
