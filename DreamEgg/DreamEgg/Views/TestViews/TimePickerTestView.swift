//
//  TimePickerTestView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/14.
//

import SwiftUI

struct TimePicker: View {
    enum TimePickerStyle {
        case hour(
            range: [Int],
            selectedHour: Binding<Int>
        )
        case minute(
            range: [Int],
            selectedMinute: Binding<Int>
        )
        case ampm(selectedAMPM: Binding<String>)
    }
    
    let style: TimePickerStyle
    
    var body: some View {
        eachPickerBuilder()
            .pickerStyle(.wheel)
            .frame(width: 75)
            .labelsHidden()
    }
    
    @ViewBuilder
    private func eachPickerBuilder() -> some View {
        switch style {
        case let .hour(range, selectedHour):
            Picker(selection: selectedHour) {
                ForEach(range, id: \.self) { eachTime in
                    Text("\(eachTime)")
                        .font(.dosIyagiBold(.largeTitle))
                        .foregroundColor(.white)
                }
            } label: {
                Text("Hour")
            }

        case let .minute(range, selectedMinute):
            Picker(selection: selectedMinute) {
                ForEach(range, id: \.self) { eachTime in
                    Text(eachTime.description)
                        .font(.dosIyagiBold(.largeTitle))
                        .foregroundColor(.white)
                }
            } label: {
                Text("Min")
            }
            
        case let .ampm(selectedAMPM):
            Picker(selection: selectedAMPM) {
                Text("PM")
                    .font(.dosIyagiBold(.largeTitle))
                    .foregroundColor(.white)
                
                Text("AM")
                    .font(.dosIyagiBold(.largeTitle))
                    .foregroundColor(.white)
                
            } label: {
                Text("?")
            }
        }
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


struct TimePickers: View {
    @ObservedObject var model: TimePickerModel
    
    var body: some View {
        ZStack {
            timePickerBackgroundView()
            
            HStack {
                TimePicker(
                    style: .hour(
                        range: model.hourArr,
                        selectedHour: $model.selectedHour
                    )
                )
                
                Text(":")
                
                TimePicker(
                    style: .minute(
                        range: model.minuteArr,
                        selectedMinute: $model.selectedMinute
                    )
                )
                
                TimePicker(
                    style: .ampm(
                        selectedAMPM: .constant("")
                    )
                )
            }
            .frame(width: 30.5 * 10, height : 30.5 * 6)
            .foregroundColor(.white)
            .clipShape(Ellipse())
            
            VStack {
                
            }
        }
    }
    
    private func timePickerBackgroundView() -> some View {
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
                .frame(width: 250 , height: 30)
                .cornerRadius(10)
                .foregroundColor(Color.black)
                .opacity(0.1)
        }
    }
}

struct TimePickerTestView: View {
    @StateObject var timePickerModel: TimePickerModel = TimePickerModel()
    
    var body: some View {
        VStack(spacing: 50) {
            TimePickers(model: timePickerModel)
                .foregroundColor(Color.dreamPurple)
            
            Button(action: {
                
            }) {
                Text("시간 설정")
                    .font(.dosIyagiBold(.title))
                    .foregroundColor(.white)
            }
            .buttonStyle(.borderedProminent)
            
            Text("\(timePickerModel.selectedHour)")
            
            Text("\(timePickerModel.selectedMinute)")
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.dreamPurple)
    }
}

struct TimePickerTestView_Previews: PreviewProvider {
    static var previews: some View {
//        TimePickers(model: .init())
        TimePickerTestView()
//        ZStack {
//            Ellipse()
//                .foregroundColor(.white)
//                .frame(width: 33 * 10, height: 33 * 6)
//
//            Ellipse()
//                .frame(width: 32 * 10, height: 32 * 6)
//
//            Ellipse()
//                .foregroundColor(.white)
//                .frame(width: 31 * 10, height: 31 * 6)
//
//            Ellipse()
//                .frame(width: 30.5 * 10, height: 30.5 * 6)
//
//            Rectangle()
//                .frame(width: 210 , height: 30)
//                .cornerRadius(10)
//                .foregroundColor(Color.black)
//                .opacity(0.1)
//
//            HStack(spacing: 10) {
//                TimePicker(
//                    title: "hour",
//                    range: 1...12,
//                    binding: $model.selectedHour
//                )
//
//                Text(":")
//                    .font(.dosIyagiBold(.largeTitle))
//                    .foregroundColor(Color.white)
//                    .fontWeight(.bold)
//
//                TimePicker(
//                    title: "minute",
//                    range: 0...60,
//                    binding: $model.selectedMinute
//                )
//
//                TimePicker(
//                    title: "ampm",
//                    range: 0...10,
//                    binding: $model.selectedAMPM
//                )
//            }
//            .frame(width: 30.5 * 10, height : 30.5 * 6)
//            .clipShape(Ellipse())
//        }
    }
}
