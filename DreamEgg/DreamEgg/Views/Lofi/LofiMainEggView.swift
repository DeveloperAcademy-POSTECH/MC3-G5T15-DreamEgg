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
    
    @State private var currentTime: Date = .now
    @State private var timer: Timer.TimerPublisher = Timer
        .publish(every: 60, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 36)
            
            DETitleHeader(title: "Dream Egg")
            
            Spacer()
                .frame(maxHeight: 36)
            
            if userSleepConfigStore.hasUserEnoughTimeToProcess() {
                failedSleepTimeView()
                    .multilineTextAlignment(.center)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
            } else {
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
                            Text("탭해서 \n알그리기")
                                .font(.dosIyagiBold(.body))
                                .foregroundColor(.white)
                        }
                }
            }
        }
        .onAppear {
            cancellable = self.timer.connect()
        }
        .onReceive(timer) { _ in
            // 1분마다 currentTime 갱신
            withAnimation {
                currentTime = Date.now
            }
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
                navigationManager.viewCycle = .timeSetting
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
            Text("잠들기까지\n\(userSleepConfigStore.formattedDateHourAndMinute())\n남았어요.")
                .font(.dosIyagiBold(.title))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(12)
            
            Button {
                withAnimation {
                    navigationManager.starterPath.removeLast()
                    
                    navigationManager.repeatStarterProcess()
                }
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
}

struct LofiMainEggView_Previews: PreviewProvider {
    static var previews: some View {
        LofiMainTabView()
            .environmentObject(DENavigationManager())
            .environmentObject(UserSleepConfigStore())
    }
}
