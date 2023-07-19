//
//  TimePickerTestView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/14.
//

import SwiftUI

struct TimePicker: View {
    let title: String
    let range: ClosedRange<Int>
    let binding: Binding<Int>
    
    var body: some View {
            Picker(title, selection: binding) {
                ForEach(range, id: \.self) { timeIncrement in
                    HStack() {
                        Text(stringHandling(num: timeIncrement, range: range))
                            .font(.dosIyagiBold(.largeTitle))
                            .foregroundColor(.white)
                        
                    }
                }
            }
            .frame(width: 75)
            .padding(-10)
            .pickerStyle(.wheel)
            .labelsHidden()
    }
    
    func stringHandling(num: Int, range: ClosedRange<Int>) -> String {
        
        if range.upperBound == 1 {
            if num == 0 {
                return "AM"
            }
            
            else {
                return "PM"
            }
        }
        
        if range.upperBound == 12 * 20 && num % (range.upperBound / 20) == 0 {
            return "12"
        }
        
        return String(format: "%02d", num % (range.upperBound / 20))
    }
}


struct TimePickers : View {
    @ObservedObject private var model = TimePickerModel()
    
    var body : some View {
        ZStack {
            Ellipse()
                .foregroundColor(.white)
                .frame(width: 33 * 10, height: 33 * 6)
            
            Ellipse()
                .frame(width: 32 * 10, height: 32 * 6)
            
            Ellipse()
                .foregroundColor(.white)
                .frame(width: 31 * 10, height: 31 * 6)
            
            Ellipse()
                .frame(width: 30.5 * 10, height: 30.5 * 6)
            
            Rectangle()
                .frame(width : 210 , height : 30)
                .cornerRadius(10)
                .foregroundColor(Color.black)
                .opacity(0.1)
            
            HStack(spacing: 10) {
                TimePicker(title: "hour", range: model.hoursRange, binding: $model.selectedHour)
                
                Text(":")
                    .font(.dosIyagiBold(.largeTitle))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                
                TimePicker(title: "minute", range: model.minutesRange, binding: $model.selectedMinute)
                
                TimePicker(title: "ampm", range: model.AMPMRange, binding: $model.selectedAMPM)
            }
            .frame(width: 30.5 * 10, height : 30.5 * 6)
            .clipShape(Ellipse())
        }
    }
}

struct TimePickerTestView: View {
    var body: some View {
        VStack(spacing: 50) {
            TimePickers()
                .foregroundColor(Color.dreamPurple)
            
            Button(action: {
                
            }) {
                Text("시간 설정")
                    .font(.dosIyagiBold(.title))
                    .foregroundColor(.white)
                    
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.dreamPurple)
    }
}

struct TimePickerTestView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerTestView()
    }
}
