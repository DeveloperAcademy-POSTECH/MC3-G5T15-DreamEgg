//
//  DECalendarTestView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import SwiftUI

struct DECalendarTestView: View {
    @EnvironmentObject var dailySleepInfoStore: DailySleepTimeStore
    
    private var calendar: Calendar
    private let monthDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    @State private var selectedDate: Date = Date.now
    @State private var selectedWeek: [Date] = []
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 30)
            
            DETitleHeader(title: "Calendar")
            
            DECalendar(
                style: .week,
                calendar: calendar,
                date: $selectedDate
            ) { eachDay, selectedWeek in
                Button {
                    self.selectedDate = eachDay
                    self.selectedWeek = selectedWeek
                    dailySleepInfoStore.assignDailySleep(at: eachDay)
                } label: {
                    VStack(spacing: 12) {
                        Text(weekDayFormatter.string(from: eachDay))
                        
                        Text(dayFormatter.string(from: eachDay))
                        
                        Image(systemName: "circle.fill")
                            .foregroundColor(eachDayForegroundColor(eachDay))
                    }
                    .foregroundStyle(
                        calendar.isDate(eachDay, inSameDayAs: selectedDate) ? .primary : .secondary)
                    .foregroundColor(calendar.isDate(eachDay, inSameDayAs: selectedDate) ? .white : .black)
                    .frame(maxWidth: 44, maxHeight: 110)
                    .background {
                        if calendar.isDate(eachDay, inSameDayAs: selectedDate) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.accentColor)
                        }
                    }
                    .onAppear {
                        self.selectedWeek = selectedWeek
                        dailySleepInfoStore.assignDailySleep(at: eachDay)
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
                .foregroundColor(.black)
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
                        selectedDaySleepInfoSection()
                        
                        selectedWeekSleepInfoSection()
                    }
                }
            }
        }
    }
    
    // MARK: LifeCycle
    init() {
        self.calendar = Calendar.getCurrentCalendar()
        
        self.monthDayFormatter = DateFormatter(dateFormat: "M", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
        self.timeFormatter = DateFormatter(dateFormat: "H:mm", calendar: calendar)
    }
    
    // MARK: ViewBuilders
    private func selectedDaySleepInfoSection() -> some View {
        Section {
            HStack {
                if let selectedDailySleep = dailySleepInfoStore.selectedDailySleep,
                   hasSelectedDateWellSlept(in: selectedDailySleep) {
                    // MARK: 3시간이 넘어야 부활한다!
                    dailySleepCardCell(by: selectedDailySleep)
                } else {
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
                }
            }
        } header: {
            Text("선택한 날")
                .font(.dosIyagiBold(.title3))
                .foregroundColor(.white)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(16)
        }
    }
    
    private func selectedWeekSleepInfoSection() -> some View {
        Section {
            let wellSleptArray = eachWeeksWellSleptArrayBuilder()
            if wellSleptArray.isEmpty {
                HStack {
                    Text("이 주엔")
                    
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
            } else {
                ForEach(wellSleptArray) { dailySleep in
                    dailySleepCardCell(by: dailySleep)
                }
            }
            
        } header: {
            Text("이번 주")
                .font(.dosIyagiBold(.title3))
                .foregroundColor(.white)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(16)
        }
    }
    
    private func dailySleepCardCell(
        by dailySleep: DailySleep
    ) -> some View {
        NavigationLink {
            CreatureDetailView()
                .onAppear {
                    // MARK: Change Selected DailySleep
                    dailySleepInfoStore.assignDailySleep(at: dailySleep.date!)
                }
        } label: {
            HStack(alignment: .center) {
                Spacer()
                    .frame(maxWidth: 20)
                
                Image("\(dailySleep.assetName!)"+"_Face")
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
                    Text("\(dailySleep.animalName!)")
                        .font(.dosIyagiBold(.callout))
                    
                    Text("\(dailySleep.date!.formatted()) 출생")
                        .font(.dosIyagiBold(.footnote))
                }
                .foregroundColor(.black)
                
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
        }
        
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
    
    private func eachDayForegroundColor(_ eachDay: Date) -> Color {
        dailySleepInfoStore.hasWellSleptDailySleep(in: eachDay)
        ? .eggYellow
        : .gray
    }
    
    private func eachWeeksWellSleptArrayBuilder() -> [DailySleep] {
        dailySleepInfoStore.dailySleepArray.filter { eachDailySleep in
            var res = false
            for eachDay in selectedWeek {
                res = eachDailySleep.sleepTimeInMinute >= 1 &&
//                res = eachDailySleep.sleepTimeInMinute >= 3 * 60 &&
                Date.isSameDate(lhs: eachDay, rhs: eachDailySleep.date!)
                if res { break }
            }
            return res
        }
        .sorted { lhs, rhs in
            lhs.date! > rhs.date!
        }
    }
    
    private func hasSelectedDateWellSlept(
        in selectedDailySleep: DailySleep
    ) -> Bool {
        if selectedDailySleep.sleepTimeInMinute >= 1,
//        if selectedDailySleep.sleepTimeInMinute >= 3 * 60,
           Date.isSameDate(lhs: selectedDate, rhs: selectedDailySleep.date!) {
            return true
        } else {
            return false
        }
    }
}

struct DECalendarTestView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GradientBackgroundView()
            
            DECalendarTestView()
        }
        .environmentObject(DailySleepTimeStore())
    }
}
