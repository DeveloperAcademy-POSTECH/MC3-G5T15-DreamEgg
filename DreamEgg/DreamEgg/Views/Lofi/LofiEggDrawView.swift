//
//  LofiEggDrawView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/24.
//

import SwiftUI

struct LofiEggDrawView: View {
    @StateObject private var eggDrawStore = EggDrawStore()
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            if eggDrawStore.isDrawEgg {
                LofiEggInteractionView()
                    .navigationBarBackButtonHidden()
            } else {
//                VStack {
                    ZStack {
                        Image("emptyEgg")
//                        eggDrawStore.includeEllipsePath
//                            .foregroundColor(.green)
//                            .opacity(0.5)
//                        
//                        eggDrawStore.exceptEllipsePath
//                            .foregroundColor(.red)
//                            .opacity(0.5)
                        
                        DrawShape(points: eggDrawStore.points)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .overlay {
                        VStack {
                            Spacer()
                                .frame(maxHeight: 98)
                            
                            Text("오늘의 내가 꿀 꿈을\n 생각하며 알을 그려주세요.")
                                .multilineTextAlignment(.center)
                                .font(.dosIyagiBold(.title))
                                .foregroundColor(.white)
                                .lineSpacing(12)
                        }
                        .frame(
                            maxHeight: .infinity,
                            alignment: .top
                        )
                    }
//                }   
            }
        }
        .animation(eggDrawStore.isDrawEgg ? Animation.easeInOut : nil)
        .gesture(eggDrawStore.gesture())
    }
}

struct LofiEggDrawView_Previews: PreviewProvider {
    static var previews: some View {
        LofiEggDrawView()
    }
}
