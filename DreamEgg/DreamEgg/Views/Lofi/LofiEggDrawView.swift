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
            }
        }
        .onAppear {
            dailySleepTimeStore.makeNewDailySleepToStartDailySleep()
            print("Hi", "\(dailySleepTimeStore.currentDailySleep!.animalName ?? "없어")")
            print("dreamEgg", "\(dailySleepTimeStore.currentDailySleep!.eggName ?? "알이가 없다")")
        }
        .navigationBarBackButtonHidden()
        .animation(eggDrawStore.isDrawEgg ? Animation.easeInOut : nil)
        .gesture(eggDrawStore.gesture())
        .simultaneousGesture(DragGesture().onChanged(onSwipeBack))
    }
    
    private func onSwipeBack(gesture: DragGesture.Value) {
            if gesture.location.x < 130 && gesture.translation.width > 80 && !eggDrawStore.isDrawEgg {
                withAnimation {
                    navigationManager.viewCycle = .general
                }
            }
        }
    
}

struct LofiEggDrawView_Previews: PreviewProvider {
    static var previews: some View {
        LofiEggDrawView()
    }
}
