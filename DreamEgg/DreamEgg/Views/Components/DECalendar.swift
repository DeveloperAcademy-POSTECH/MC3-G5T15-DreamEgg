//
//  DECalendar.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import SwiftUI

struct DECalendar<DayLabel: View, Header: View, WeekSwitcher: View>: View {
    enum DECalendarStyle {
        case week
        /// 이건 아마 안쓸듯
        case month
    }
    
    let style: DECalendarStyle
    private var calendar: Calendar
    private let content: (Date) -> DayLabel
    private let monthHeader: () -> Header
    private let weekSwitcher: () -> WeekSwitcher
    @Binding var date: Date
    
    var body: some View {
        switch style {
        case .week:
            let days = makeDays()
            
            VStack {
                HStack {
                    // Header
                    self.monthHeader()
                    
                    // Chevron
                    self.weekSwitcher()
                }
                
                Divider()
                
                HStack {
                    ForEach(days, id: \.self) { eachDay in
                        content(eachDay)
                    }
                }
                
                Divider()
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
        case .month:
            Text("Month")
        }
    }
    
    public init(
        style: DECalendarStyle,
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> DayLabel,
        @ViewBuilder monthHeader: @escaping () -> Header,
        @ViewBuilder weekSwitcher: @escaping () -> WeekSwitcher
    ) {
        self.style = style
        self.calendar = calendar
        self._date = date
        self.content = content
        self.monthHeader = monthHeader
        self.weekSwitcher = weekSwitcher
    }
    
    /**
     각 주를 구성하는 요일들을 구성합니다.
     이 배열을 바탕으로 가로 스크롤 컴포넌트를 렌더링합니다.
     */
    func makeDays() -> [Date] {
        guard let firstWeek = calendar.dateInterval(
            of: .weekOfMonth, for: date),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: firstWeek.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(
            start: firstWeek.start,
            end: lastWeek.end
        )
        
        return calendar.generateDays(for: dateInterval)
    }
}

struct DECalendar_Previews: PreviewProvider {
    static var previews: some View {
        DECalendarTestView()
    }
}

struct DECalendarComponents {
    let calendar: Calendar
    let monthDayFormatter: DateFormatter
    let dayFormatter: DateFormatter
    let weekDayFormatter: DateFormatter
    let timeFormatter: DateFormatter
}
