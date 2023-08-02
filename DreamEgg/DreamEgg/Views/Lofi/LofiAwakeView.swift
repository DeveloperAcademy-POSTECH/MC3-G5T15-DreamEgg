//
//  LofiAwakeView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/19.
//

import Combine
import SwiftUI

struct LofiAwakeView: View {
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    @EnvironmentObject var navigationManager: DENavigationManager
    @Environment(\.scenePhase) var scene
    @State private var currentTime: Date = .now
    @State private var maskColor = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8))
    @State private var isEggButtonTapped = false
    @State private var isActiveSpringAnimation = false
    @State private var timer: Timer.TimerPublisher = Timer
        .publish(every: 15, on: .main, in: .common)
        
    @State private var cancellable: Cancellable?
    
    private let hourFormatter = DateFormatter(
        dateFormat: "H",
        calendar: .current
    )
    
    private let minuteFormatter = DateFormatter(
        dateFormat: "mm",
        calendar: .current
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                        .frame(maxHeight: 100)
                    
                    DEFontStyle(style: .largeTitle, text: "지금 시간은 \n\(currentTime.hour)시 \(currentTime.minute)분이에요.")
                    
                    if isUserSleepingMoreThanThreeHours() {
                        ZStack {
                            Button {
                                disableEggButtonToActiveConfetti()
                            } label: {
                                Image("EggPillow")
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .padding(.top, 170)
                                    .overlay {
                                        Image("\(dailySleepTimeStore.currentDailySleep?.eggName ?? Constant.Errors.NO_EGG)")
                                            .resizable()
                                            .frame(width: 160, height: 160)
                                    }
                                    .overlay {
                                        Image("ShinyMiddle")
                                            .resizable()
                                            .rotationEffect(.degrees(80))
                                            .frame(width: isActiveSpringAnimation ? 25 : 60, height: isActiveSpringAnimation ? 25 : 60)
                                            .padding(.bottom, 140)
                                            .padding(.trailing, 50)
                                            .animation(.spring(response: 1.5, dampingFraction: 0.45, blendDuration: 0.2))
                                    }
                                    .overlay {
                                        Image("ShinySmall")
                                            .resizable()
                                            .rotationEffect(.degrees(40))
                                            .frame(width: isActiveSpringAnimation ? 15 : 20, height: isActiveSpringAnimation ? 15 : 20)
                                            .padding(.bottom, 90)
                                            .padding(.trailing, 90)
                                            .animation(.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.2))
                                    }
                                
                                
                            }
                            .disabled(isEggButtonTapped)
                            
                            
                            if isEggButtonTapped {
                                Image("ShinyMiddle")
                                    .activateConfetti()
                            }
                        }
                        
                        // 추후 currentTime 대신에 수면 시작 시간으로부터 누적 된 값이 들어가야 함.
                        DEFontStyle(style: .title3, text: "\(dailySleepTimeStore.sleptHour)시간 \(dailySleepTimeStore.sleptMinute)분 동안 알을 품었네요.\n잠은 충분히 주무셨나요?")
                            .padding()
                        
                        DEFontStyle(style: .body, text: "이제 알의 변화를 살필 수 있어요.")
                            .foregroundColor(.white.opacity(0.6))
                            .colorInvert()
                        
                        Spacer()
                        
                        NavigationLink {
                            LofiBirthView()
                                .onAppear {
                                    dailySleepTimeStore.completeDailySleepTime()
                                }
                        } label: {
                            Text("잘 잤어요!")
                            //                    Text("I slept well!")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.primaryButtonBrown)
                                .font(.dosIyagiBold(.body))
                                .tracking(-1)
                            
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primaryButtonBrown, lineWidth: 5)
                                }
                            
                        }
                        .background { Color.primaryButtonYellow }
                        .cornerRadius(8)
                        .padding(.horizontal)
                    } else {
                        Spacer()
                        Image("\(dailySleepTimeStore.currentDailySleep?.eggName ?? Constant.Errors.NO_EGG)")
                            .resizable()
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(90))
                            .overlay {
                                Image("EggHat")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(60))
                                    .padding(.bottom, 80)
                                    .padding(.leading, 180)
                            }
                            .overlay {
                                Image("EggPillow")
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .rotationEffect(.degrees(-25))
                                    .padding(.bottom, 80)
                                    .padding(.trailing, 40)
                            }
                            .overlay {
                                Rectangle()
                                    .fill(maskColor)
                                    .frame(width: 300, height: 300)
                            }
                            .overlay {
                                DEFontStyle(style: .callout, text: "Zzz...")
                                    .padding(.top, 70)
                                    .padding(.leading, 110)
                            }
                        
                        Spacer()
                        
                        // 추후 currentTime 대신에 수면 시작 시간으로부터 누적 된 값이 들어가야 함.
                        DEFontStyle(style: .title3, text: "\(dailySleepTimeStore.sleptHour)시간 \(dailySleepTimeStore.sleptMinute)분 동안 알을 품었네요.\n좀 더 주무셔야겠어요.")
                            .padding()
                        
                        DEFontStyle(style: .body, text: "화면을 다시 잠그면\n알을 더 오래 품을 수 있어요.")
                            .foregroundColor(.white.opacity(0.6))
                            .colorInvert()
                        
                        Spacer()
                        
                        NavigationLink {
                            LofiFailedView()
                                .onAppear {
                                    dailySleepTimeStore.updateDailyInfoProcessToStop()
                                }
                            //                      Text("To Fail screen")
                        } label: {
                            Text("잠이 안와서 내일 할게요.")
                            //                      Text("I don't feel like to sleep")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.subButtonBlue)
                                .font(.dosIyagiBold(.body))
                                .tracking(-1)
                            
                        }
                        .background { Color.subButtonSky }
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .onAppear {
                    dailySleepTimeStore.getSleepTimeInMinute()
                    self.isActiveSpringAnimation.toggle()
                }
                .onChange(of: scene) { newScene in
                    self.currentTime = .now
                    
                    if isChangingFromInactiveScene(into: newScene) {
                        dailySleepTimeStore.getSleepTimeInMinute()
                        self.cancellable = timer.connect()
                    }
                }
                .onDisappear {
                    self.cancellable?.cancel()
                }
            }
        }
    }
    
    /// egg를 탭하면 eggtab의 값이 toggle되어 confetti가 적용 된 sparkle 이미지가 나타나고,
    /// 3초간 버튼 기능을 비활성합니다. 3초 후에는 각 토글을 다시 false로 전환합니다.
    private func disableEggButtonToActiveConfetti() {
        isEggButtonTapped = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isEggButtonTapped = false
        }
    }
    
    private func isUserSleepingMoreThanThreeHours() -> Bool {
        // MARK: 10분
        // TODO: 10분을 60 * 3 으로 수정
        if let currentDailySleep = dailySleepTimeStore.currentDailySleep  {
            return dailySleepTimeStore.sleepingTimeInMinute >= 1
        } else {
            return false
        }
    }
    
    private func isChangingFromInactiveScene(into newScene: ScenePhase) -> Bool {
        
        let activated = scene == .inactive && newScene == .active ||
        scene == .background && newScene == .active
        
        print(#function, activated)
        return activated
    }
}
struct LofiAwakeView_Previews: PreviewProvider {
    static var previews: some View {
        LofiAwakeView()
    }
}
