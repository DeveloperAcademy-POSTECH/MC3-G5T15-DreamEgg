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
    @State private var timer: Timer.TimerPublisher = Timer
        .publish(every: 15, on: .main, in: .common)
    @State private var cancellable: Cancellable?
        
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 36)
            
            DETitleHeader(title: "Dream Egg")
            
            Spacer()
                .frame(maxHeight: 36)
            
            if userSleepConfigStore.hasUserEnoughTimeToProcess(currentTime: currentTime) {
                sleepPreparingView()
                    .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(maxHeight: 40)
                
                NavigationLink {
                    LofiEggDrawView()
                        .navigationBarBackButtonHidden()
                        .onAppear {
                            dailySleepTimeStore.updateAndSaveNewDailySleepInfo()
                            print("Hi", "\(dailySleepTimeStore.currentDailySleep!.animalName ?? "없어")")
                            print("dreamEgg", "\(dailySleepTimeStore.currentDailySleep!.eggName ?? "알이가 없다")")
                        }
                } label: {
                    Image("emptyEgg")
                        .overlay {
                            Text("탭해서\n드림에그를 그려보세요!")
                                .font(.dosIyagiBold(.body))
                                .foregroundColor(.white)
                                .lineSpacing(8)
                                .tracking(-2)
                        }
                }
            } else {
                failedSleepTimeView()
                    .multilineTextAlignment(.center)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )   
            }
        }
        .onAppear {
            cancellable = self.timer.connect()
        }
        .onReceive(timer) { _ in
            // 15초마다 currentTime 갱신
            withAnimation {
                currentTime = Date.now
            }
        }
    }
    
    // MARK: - ViewBuilder
    private func failedSleepTimeView() -> some View {
        VStack {
//            Spacer()
//                .frame(maxHeight: 24)
            
            Text("새로운 드림에그를\n만날 수 있게\n취침시간까지 기다려주세요.")
                .font(.dosIyagiBold(.title))
                .foregroundColor(.white)
                .lineSpacing(16)
                .tracking(-3)
                .padding(.top, 4)
            
            Button {
                withAnimation {
                    navigationManager.isFromMainTab = true
                    navigationManager.viewCycle = .timeSetting
                }
            } label: {
                Text("수면 시간 수정하기")
                    .font(.dosIyagiBold(.body))
                    .tracking(-2)
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
                        Text("1시간 전부터\n드림에그를 그릴 수 있어요!")
                            .font(.dosIyagiBold(.body))
                            .foregroundColor(.white)
                            .lineSpacing(8)
                            .tracking(-2)
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
            VStack(spacing: 16) {
                Text("잠들기까지")
                     
                Text("\(userSleepConfigStore.hourAndMinuteString(currentTime: currentTime))")
                    .font(.dosIyagiBold(.largeTitle))
                    .tracking(-2)
                
                Text("남았어요.")
            }
            .font(.dosIyagiBold(.title))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
//            .lineSpacing(12)
            .tracking(-3)
            
            Button {
                withAnimation {
                    navigationManager.viewCycle = .timeSetting
                }
            } label: {
                Text("시간 및 알림 수정하기")
                    .font(.dosIyagiBold(.body))
                    .foregroundColor(.white.opacity(0.6))
                    .lineSpacing(16)
                    .tracking(-2)
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
}

struct LofiMainEggView_Previews: PreviewProvider {
    static var previews: some View {
        LofiMainTabView()
            .environmentObject(DENavigationManager())
            .environmentObject(UserSleepConfigStore())
    }
}
