//
//  LofiMainEggView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/23.
//

import Combine
import SwiftUI

struct LofiMainEggView: View {
    @EnvironmentObject var navigationManager: DENavigationManager
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    
    @State private var mainHeaderString: String = ""
    @State private var eggString: String = ""
    @Binding var isSettingMenuDisplayed: Bool
    
    @State private var currentTime: Date = .now
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer
        .publish(every: 15, on: .main, in: .common)
        .autoconnect()
    
    @State private var cancellable: Cancellable?
    
    var body: some View {
        VStack {
            DETitleHeader(title: "Dream Egg")
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation {
                            if isSettingMenuDisplayed {
                                isSettingMenuDisplayed = false
                            } else if !isSettingMenuDisplayed {
                                isSettingMenuDisplayed = true
                            }
                        }
                        print("BUTTON TAPPED",isSettingMenuDisplayed)
                    } label: {
                        Image("SettingsIcon")
                            .padding()
                    }
                    .opacity(isSettingMenuDisplayed ? 0.7 : 1.0)
                }
            
            Spacer()
                .frame(maxHeight: 24)
            
            sleepPreparingView()
                .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(maxHeight: 100)
            
            NavigationLink {
                LofiEggDrawView()
                    .navigationBarBackButtonHidden()
            } label: {
                ZStack {
                    Image("EggPillow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                            .offset(x:0,y:160)
                        Image("emptyEgg")
                            .overlay {
                                Text(eggString)
                                    .font(.dosIyagiBold(.body))
                                    .foregroundColor(.white)
                                    .lineSpacing(8)
                                    .tracking(-1)
                            }
                    }
                }
                .disabled(!userSleepConfigStore.hasUserEnoughTimeToProcess(currentTime: currentTime))
        }
        .overlay(alignment: .topTrailing) {
            if isSettingMenuDisplayed {
                settingMenu()
                    .overlay(alignment: .center) {
                       customizedMenu()
                        .foregroundColor(.black)
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 48)
            }
        }
        .onAppear {
            self.mainHeaderString = getSleepPreparingViewString()
            self.eggString = getEggString()
        }
        .onReceive(timer) { _ in
            if userSleepConfigStore.hasUserEnoughTimeToProcess(currentTime: currentTime) {
                if !Constant.GOODNIGHT_PREPARE_MESSAGES.contains(self.mainHeaderString) {
                    self.mainHeaderString = getSleepPreparingViewString()
                }
                withAnimation {
                    currentTime = Date.now
                }
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
    // MARK: - ViewBuilder
    private func failedSleepTimeView() -> some View {
        VStack {
//            Spacer()
//                .frame(maxHeight: 24)
            DEFontStyle(style: .title, text: "새로운 드림에그를\n만날 수 있게\n취침시간까지 기다려주세요.")
                .foregroundColor(.white)
                .padding(.top, 4)
            
            Button {
                withAnimation {
                    navigationManager.isFromMainTab = true
                    navigationManager.viewCycle = .timeSetting
                }
            } label: {
                DEFontStyle(style: .body, text: "취침 시간 수정하기")
                    .foregroundColor(.white.opacity(0.6))
                    .overlay {
                        VStack {
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color.white.opacity(0.6))
                                .offset(y: 12)
                        }
                    }
                    .padding(.top, 22)
            }
            
            Button {} label: {
                Image("emptyEggDisabled")
                    .overlay {
                        DEFontStyle(style: .body, text: "1시간 전부터\n드림에그를 그릴 수 있어요!")
                            .foregroundColor(.white)
                    }
            }
            .disabled(true)
            .frame(maxHeight: .infinity)
            
//            Text("내일은 꼭 직접 알을 품어주세요!")
//                .font(.dosIyagiBold(.body))
            
            Spacer()
                .frame(maxHeight: 94)
            

        }
    }
    
    private func sleepPreparingView() -> some View {
        VStack {
            Text(mainHeaderString)
                .font(.dosIyagiBold(.title))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(16)
                .tracking(-1)
        }
    }
    
    private func settingMenu() -> some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(Color.subButtonSky)
            .frame(width: 200, height: 100)
            .transition(
                .asymmetric(
                    insertion: .opacity,
                    removal: .opacity
                )
            )
            .animation(
                .easeInOut(duration: 0.2),
                value: isSettingMenuDisplayed
            )
    }
    
    private func customizedMenu() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation {
                    navigationManager.viewCycle = .timeReset
                }
                
            } label: {
                Text("수면 시간 수정")
                    .font(.dosIyagiBold(.title3))
            }
            

            Button {
                withAnimation {
                    navigationManager.viewCycle = .notificationMessageSetting
                }
                
            } label: {
                Text("알림 메시지 수정")
                    .font(.dosIyagiBold(.title3))
            }
        }
    }
    private func getSleepPreparingViewString() -> String {
        userSleepConfigStore.hasUserEnoughTimeToProcess(currentTime: currentTime)
        ? "오늘의 취침 시간은\n\(userSleepConfigStore.targetSleepTime.hour)시 \(userSleepConfigStore.targetSleepTime.minute)분이에요!"
        : Constant.GOODNIGHT_PREPARE_MESSAGES.randomElement()!
    }
    
    private func getEggString() -> String {
        userSleepConfigStore.hasUserEnoughTimeToProcess(currentTime: currentTime)
        ? "탭해서\n드림에그를 그려보세요!"
        : "잠들기 1시간 전부터\n알을 그릴 수 있어요!"
    }
}

struct LofiMainEggView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GradientBackgroundView()
            
            LofiMainEggView(isSettingMenuDisplayed: .constant(false))
                .environmentObject(DENavigationManager())
                .environmentObject(UserSleepConfigStore())
                .environmentObject(DailySleepTimeStore())
        }
    }
}
