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
    
    @State private var currentTime: Date = .now
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer
        .publish(every: 15, on: .main, in: .common)
        .autoconnect()
    
    @State private var cancellable: Cancellable?
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 36)
            
            DETitleHeader(title: "Dream Egg")
            
            Spacer()
                .frame(maxHeight: 36)
            
            sleepPreparingView()
                .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(maxHeight: 40)
            
            NavigationLink {
                LofiEggDrawView()
                    .navigationBarBackButtonHidden()
            } label: {
                Image("emptyEgg")
                    .overlay {
                        Text(getEggString())
                            .font(.dosIyagiBold(.body))
                            .foregroundColor(.white)
                            .lineSpacing(8)
                            .tracking(-1)
                    }
            }
            .disabled(!userSleepConfigStore.hasUserEnoughTimeToProcess(currentTime: currentTime))
        }
        .onReceive(timer) { _ in
            if userSleepConfigStore.hasUserEnoughTimeToProcess(
                currentTime: currentTime
            ) {
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
            Text(getSleepPreparingViewString())
                .font(.dosIyagiBold(.title))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(16)
                .tracking(-1)
            Button {
                navigationManager.viewCycle = .timeSetting
            } label: {
                DEFontStyle(style: .body, text: "시간 및 알림 수정하기")
                    .foregroundColor(.white.opacity(0.6))
                    .overlay {
                        VStack {
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color.white.opacity(0.6))
                                .offset(y: 12)
                        }
                    }
                    .padding()
            }
        }
    }
    private func getSleepPreparingViewString() -> String {
        userSleepConfigStore.hasUserEnoughTimeToProcess(currentTime: currentTime)
        ? "잠들기까지\n\(userSleepConfigStore.hourAndMinuteString(currentTime: currentTime))\n남았어요."
        : Constant.GOODNIGHT_PREPARE_MESSAGES.randomElement()!
    }
    
    private func getEggString() -> String {
        userSleepConfigStore.hasUserEnoughTimeToProcess(currentTime: currentTime)
        ? "탭해서\n알그리기"
        : "잠들기 1시간 전부터\n알을 그릴 수 있어요!"
    }
}

//struct LofiMainEggView_Previews: PreviewProvider {
//    static var previews: some View {
//        LofiMainTabView()
//            .environmentObject(DENavigationManager())
//            .environmentObject(UserSleepConfigStore())
//    }
//}
