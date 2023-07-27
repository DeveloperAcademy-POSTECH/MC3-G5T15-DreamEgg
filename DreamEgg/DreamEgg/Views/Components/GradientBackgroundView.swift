//
//  GradientBackgroundView.swift
//  DreamEgg
//
//  Created by SUNGIL-POS on 2023/07/10.
//

import SwiftUI
import CoreData

struct GradientBackgroundView: View {
    /** Calendar에서 가져 온 사용자의 시간 값
     */
//    let hour = Calendar.current.component(.hour, from: Date())
    
    // 밤에 보이는 GradientColor
    @State var startColorNightTime = Color(#colorLiteral(red: 0.6274509804, green: 0.5725490196, blue: 0.7843137255, alpha: 1))
    @State var endColorNightTime = Color(#colorLiteral(red: 0.4666666667, green: 0.5215686275, blue: 0.8156862745, alpha: 1))

    // 낮에 보이는 GradientColor
//    @State var startColorDayTime = Color(#colorLiteral(red: 0.6392156863, green: 0.8039215686, blue: 1, alpha: 1))
//    @State var endColorDayTime = Color(#colorLiteral(red: 1, green: 0.7960784314, blue: 0.2705882353, alpha: 1))
    
    var body: some View {
        ZStack {
            // 사용자의 시간이 18시 ~ 05시 사이
//            if hour < 5 || hour > 18 {
                LinearGradient(gradient: Gradient(colors: [startColorNightTime, endColorNightTime]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
//            }
            // 사용자의 시간이 05시 ~ 18시 사이
//            else {
//                LinearGradient(gradient: Gradient(colors: [startColorDayTime, endColorDayTime]), startPoint: .top, endPoint: .bottom)
//                    .edgesIgnoringSafeArea(.all)
//            }
        }
        // GradientColor가 부드럽게 바뀌는 Animation
//        .animation(.spring(response: 3,  blendDuration: 10))
    }
}

struct GradientBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackgroundView()
    }
}
