//
//  LofiEggDrawView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/24.
//

import SwiftUI

struct LofiEggDrawView: View {
    @EnvironmentObject var navigationManager: DENavigationManager
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    @StateObject private var eggDrawStore = EggDrawStore()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            GradientBackgroundView()
            if eggDrawStore.isDrawEgg {
                LofiEggInteractionView()
                    .navigationBarBackButtonHidden()
                    .onAppear {
                        dailySleepTimeStore.makeNewDailySleepToStartDailySleep()
                    }
            } else {
                    ZStack {
                        Image("emptyEgg")
                        
                        DrawShape(points: eggDrawStore.points)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .overlay {
                        VStack {
                            Spacer()
                                .frame(maxHeight: 98)
                            
                            Text("오늘 내가 꿀 꿈을 생각하며\n드림에그를 그려주세요.")
                                .multilineTextAlignment(.center)
                                .font(.dosIyagiBold(.title))
                                .foregroundColor(.white)
                                .lineSpacing(16)
                        }
                        .frame(
                            maxHeight: .infinity,
                            alignment: .top
                        )
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .animation(eggDrawStore.isDrawEgg ? Animation.easeInOut : nil)
        .gesture(eggDrawStore.gesture())
        .simultaneousGesture(DragGesture().onChanged(onSwipeBack))
    }
    
    private func onSwipeBack(gesture: DragGesture.Value) {
            if gesture.location.x < 130 && gesture.translation.width > 80 && !eggDrawStore.isDrawEgg {
                presentationMode.wrappedValue.dismiss()
            }
        }
    
}

struct LofiEggDrawView_Previews: PreviewProvider {
    static var previews: some View {
        LofiEggDrawView()
    }
}
