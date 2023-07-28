//
//  DECalendarTestView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import SwiftUI

struct DECalendarTestView: View {
    @Binding var confirmedName: String
    
    private var calendar: Calendar
    
    private let monthDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let timeFormatter: DateFormatter
//
    @State private var selectedDate: Date = Date.now
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 30)
            
            DETitleHeader(title: "Calendar")
            
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
                        
                        Image(systemName: "circle.fill")
                    }
                    .foregroundStyle(calendar.isDate(date, inSameDayAs: selectedDate) ? .primary : .secondary)
                    .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                    .frame(maxWidth: 44, maxHeight: 110)
                    .background {
                        if calendar.isDate(
                            date,
                            inSameDayAs: selectedDate
                        ) {
                            Capsule()
                                .fill(Color.accentColor)
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
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.subButtonSky)
            }
            .padding()
            
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        HStack {
                            Text("이 날은")

                            Text("드림펫")
                                .foregroundColor(.subButtonBlue)
                            
                            + Text("이 태어나지 않았어요.")
                        }
                        .font(.dosIyagiBold(.footnote))
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background {
                            Capsule()
                                .fill(Color.subButtonSky)
                                .padding(.horizontal)
                        }
                    } header: {
                        Text("Selected Day")
                            .font(.dosIyagiBold(.title3))
                            .foregroundColor(.white)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(16)
                    }
                    NavigationLink {
                        CreatureDetailView()
                    } label: {
                        Section {
                            HStack(alignment: .center) {
                                Spacer()
                                    .frame(maxWidth: 20)
                                
                                Image("Quokka_Face")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 80, maxHeight: 80)
                                    .background {
                                        Circle()
                                            .fill(Color.eggYellow)
                                            .frame(maxWidth: 60, maxHeight: 60)
                                    }
                                    .background {
                                        Circle()
                                            .fill(Color.primaryButtonYellow)
                                            .frame(maxWidth: 70, maxHeight: 70)
                                    }
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 8
                                ) {
                                    Text("꿔까")
                                        .font(.dosIyagiBold(.callout))
                                    
                                    Text("\(timeFormatter.string(from: Date.now)) 출생")
                                        .font(.dosIyagiBold(.footnote))
                                }
                                
                                Spacer()
                                    .frame(maxWidth: 30)
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .background {
                                Capsule()
                                    .fill(Color.subButtonSky)
                                    .padding(.horizontal)
                            }
                        } header: {
                            Text("This Week")
                                .font(.dosIyagiBold(.title3))
                                .foregroundColor(.white)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .padding(16)
                        }
                    }
                    
                }
            }
        }
    }
    
    // MARK: LifeCycle
    init(confirmedName: Binding<String>) {
        self.calendar = Calendar.getCurrentCalendar()

        self.monthDayFormatter = DateFormatter(dateFormat: "M", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
        self.timeFormatter = DateFormatter(dateFormat: "H:mm", calendar: calendar)
        self._confirmedName = confirmedName
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
        ZStack {
            GradientBackgroundView()
            
            DECalendarTestView(confirmedName: .constant("Quokka"))
        }
    }
}
