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
            Text("정말 바쁜 하루였네요.\n오늘은 제가 대신\n알을 품어드릴게요.")
                .font(.dosIyagiBold(.title))
                .padding()
            
            Text("내일은 꼭 직접 알을 품어주세요!")
                .font(.dosIyagiBold(.body))
            
            Spacer()
                .frame(maxHeight: 50)
            
            Button {
                withAnimation {
                    navigationManager.isFromMainTab = true
                    navigationManager.viewCycle = .timeSetting
                }
            } label: {
                Text("수면 시간 수정하기")
                    .font(.dosIyagiBold(.body))
                    .foregroundColor(.white)
                    .overlay {
                        VStack {
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color.white)
                                .offset(y: 12)
                        }
                    }
                    .padding()
            }
        }
    }
    
    private func sleepPreparingView() -> some View {
        VStack {
            Text(getSleepPreparingViewString())
                .font(.dosIyagiBold(.title))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(12)
            
            Button {
                navigationManager.viewCycle = .timeSetting
            } label: {
                Text("시간 및 알림 수정하기")
                    .font(.dosIyagiBold(.body))
                    .foregroundColor(.white)
                    .overlay {
                        VStack {
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color.white)
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
