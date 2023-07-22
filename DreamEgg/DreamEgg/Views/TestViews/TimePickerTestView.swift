//
//  TimePickerTestView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/14.
//

import SwiftUI

struct TimePickerTestView: View {
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 50) {
            TimePickerView(flag: $isPressed)
                .foregroundColor(Color.dreamPurple)
            
            Button(action: {
                    isPressed = true
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
