//
//  LofiMainEggView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI
import Combine

struct LofiMainEggView: View {
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    @State private var tabSelection: Int = 1
    @State private var currentTime: Date = .now
    
    @State private var timer: Timer.TimerPublisher = Timer
        .publish(every: 60, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    
    private var targetSleepTime: Date {
        if let targetSleepTime = userSleepConfigStore.userSleepConfig.targetSleepTime {
            return targetSleepTime
        } else {
            return .now
        }
    }
    
    private var calculatedDateHourAndMinute: String {
        let currentDay = currentTime.day
        let leftHour = targetSleepTime.hour - currentTime.hour
        let leftMinute = targetSleepTime.minute - currentTime.minute
        
        return leftHour != 0
        ? "\(leftHour)시간 \(leftMinute)분"
        : "\(leftMinute)분"
    }
    
    private var hasUserEnoughTimeToProcess: Bool {
        if currentTime.hour > targetSleepTime.hour
            && currentTime.minute > targetSleepTime.minute {
            return true
        } else {
            return false
        }
        
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            TabView(selection: $tabSelection) {
                DECalendarTestView()
                    .tag(0)
                    .tabItem {
                        Image("CalendarTabIcon")
                    }
                
                // MARK: Main Egg
                VStack {
                    Spacer()
                        .frame(maxHeight: 36)
                    
                    DETitleHeader(title: "Dream Egg")
                    
                    Spacer()
                        .frame(maxHeight: 36)
                    
                    if currentTime > targetSleepTime {
                        VStack {
                            Text("정말 바쁜 하루였네요.\n오늘은 제가 대신\n알을 품어드릴게요.")
                                .font(.dosIyagiBold(.title))
                                .padding()
                            
                            Text("내일은 꼭 직접 알을 품어주세요!")
                                .font(.dosIyagiBold(.body))
                            
                            Spacer()
                                .frame(maxHeight: 50)
                        }
                        .multilineTextAlignment(.center)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .center
                        )
                    } else {
                        VStack {
                            Text("잠들기까지\n\(calculatedDateHourAndMinute)\n남았어요.")
                                .font(.dosIyagiBold(.title))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineSpacing(12)
                            
                            NavigationLink {
                                SleepTimeSettingView()
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
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                            .frame(maxHeight: 80)
                        
                        NavigationLink {
                            LofiSleepGuideView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Ellipse()
                                .stroke(
                                    Color.white,
                                    style: StrokeStyle(
                                        lineWidth: 10,
                                        dash: [8],
                                        dashPhase: 6
                                    )
                                )
                                .frame(maxWidth: 200, maxHeight: 270)
                                .overlay {
                                    Text("탭해서 \n알그리기")
                                        .font(.dosIyagiBold(.body))
                                        .foregroundColor(.white)
                                }
                            
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .onAppear {
                    cancellable = self.timer.connect()
                }
                .onReceive(timer) { _ in
                    // 1분마다 currentTime 갱신
                    withAnimation {
                        currentTime = Date.now
                    }
                }
                .tag(1)
                .tabItem {
                    Image("DreamEggTabIcon")
                }
                
                LofiDreamWorldView()
                    .tag(2)
                    .tabItem {
                        Image("DreamWorldTabIcon")
                    }
            }
            .tabViewStyle(.page)
            
        }
        .navigationBarBackButtonHidden()
    }
}

struct LofiMainEggView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LofiMainEggView()
        }
    }
}
