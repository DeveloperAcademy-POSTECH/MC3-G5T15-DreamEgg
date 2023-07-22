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
