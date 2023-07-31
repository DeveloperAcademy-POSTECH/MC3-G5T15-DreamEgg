//
//  TimePickerView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/23.
//

import SwiftUI

struct TimePickerView: View {
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    @ObservedObject var timePickerStore: TimePickerStore
    
    var body: some View {
        ZStack {
            Ellipse()
                .foregroundColor(.white)
                .frame(width: 33 * 10, height: 33 * 6)
            
            Ellipse()
                .frame(width: 31.5 * 10, height: 31.5 * 6)
            
            Ellipse()
                .foregroundColor(.white)
                .frame(width: 30.5 * 10, height: 30.5 * 6)
            
            Ellipse()
                .frame(width: 29.5 * 10, height: 29.5 * 6)
            
            Rectangle()
                .frame(width : 210 , height : 30)
                .cornerRadius(10)
                .foregroundColor(Color.black)
                .opacity(0.1)
            
            HStack(spacing: 10) {
//                Picker("", selection: $timePickerStore.selectedElements[0]) {
                Picker("", selection: $timePickerStore.timePickerElements.hours.at) {
//                    ForEach(timePickerStore.ranges[0], id: \.self) { timeIncrement in
                    ForEach(timePickerStore.timePickerElements.hours.range, id: \.self) { timeIncrement in
                        Text(timePickerStore.transformToString(num: timeIncrement, pickerType: "hour"))
                            .font(.dosIyagiBold(.largeTitle))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 75)
                .padding(-10)
                .pickerStyle(.wheel)
                .labelsHidden()
                
                Text(":")
                    .font(.dosIyagiBold(.largeTitle))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                
//                Picker("", selection: $timePickerStore.selectedElements[1]) {
                Picker("", selection: $timePickerStore.timePickerElements.minutes.at) {
//                    ForEach(timePickerStore.ranges[1], id: \.self) { timeIncrement in
                    ForEach(timePickerStore.timePickerElements.minutes.range, id: \.self) { timeIncrement in
                        Text(timePickerStore.transformToString(num: timeIncrement, pickerType: "minute"))
                            .font(.dosIyagiBold(.largeTitle))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 75)
                .padding(-10)
                .pickerStyle(.wheel)
                .labelsHidden()
                
//                Picker("", selection: $timePickerStore.selectedElements[2]) {
                Picker("", selection: $timePickerStore.timePickerElements.ampm.is) {
//                    ForEach(timePickerStore.ranges[2], id: \.self) { timeIncrement in
                    ForEach(timePickerStore.timePickerElements.ampm.range, id: \.self) { timeIncrement in
                        Text(timePickerStore.transformToString(num: timeIncrement, pickerType: "ampm"))
                            .font(.dosIyagiBold(.largeTitle))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 75)
                .padding(-10)
                .pickerStyle(.wheel)
                .labelsHidden()
            }
            .frame(width: 30.5 * 10, height : 30.5 * 6)
            .clipShape(Ellipse())
        }
    }
}
