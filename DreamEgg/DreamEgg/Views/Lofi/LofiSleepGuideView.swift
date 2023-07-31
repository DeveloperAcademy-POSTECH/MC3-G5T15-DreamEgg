//
//  LofiSleepGuideView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/19.
//

import SwiftUI

struct LofiSleepGuideView: View {
    @frozen enum SleepGuideSteps {
        case start
        case breath
        case release
        case hug
        case darkening
    }
    
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    @EnvironmentObject var navigationManager: DENavigationManager
    
    @State private var sleepGuideSteps: SleepGuideSteps = .start
    @State private var afterHold: Bool = false
    @StateObject private var eggAnimation = EggAnimation()
    @Binding var isSkippedFromInteractionView: Bool
    
    var body: some View {
//        if afterHold {
//            LofiAwakeView()
//        } else {
            ZStack {
                GradientBackgroundView()
                    .overlay {
                        if sleepGuideSteps == .darkening {
                            Color.black
                                .opacity(0.4)
                                .ignoresSafeArea()
                        }
                    }
                
                VStack {
                    Spacer()
                        .frame(maxHeight: 100)
                    
                    if sleepGuideSteps != .darkening {
                        guideHeaderText()
                            .font(.dosIyagiBold(.title))
                            .multilineTextAlignment(.center)
                            .lineSpacing(16)
                            .tracking(-3)
                            .foregroundColor(.primary)
                            .colorInvert()
                            .frame(maxHeight: 120, alignment: .top)
                    } else if sleepGuideSteps == .darkening {
                        Text("")
                            .frame(maxHeight: 80)
                    }
                    ZStack {
                        Image("samplePillow")
                            .offset(x:0,y:160)

                        Image("\(dailySleepTimeStore.currentDailySleep?.eggName ?? Constant.Errors.NO_EGG)")

                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .rotationEffect(eggAnimation.rotationAngle, anchor: .bottom)
                            .gesture(eggAnimation.dragGesture())
                            .animation(Animation.easeInOut(duration: 1.0), value: eggAnimation.rotationAngle)
                            .onAppear {
                                eggAnimation.amplitude = 5.0
                                eggAnimation.startPendulumAnimation()
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(sleepGuideSteps == .darkening ? 0.4 : 1.0)
                        .overlay(alignment: .topTrailing) {
                            if sleepGuideSteps == .darkening {
                                HStack {
                                    guideHeaderText()
                                        .foregroundColor(.primary)
                                        .colorInvert()
                                        .font(.dosIyagiBold(.body))
                                        .lineSpacing(8)
                                        .tracking(-2)
                                        .multilineTextAlignment(.trailing)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(width: 8, height: 88)
                                        .padding(.trailing, 4)
                                }
                                .offset(y: -20)
                            }
                        }
                        .overlay(alignment: .bottom) {
                            if sleepGuideSteps == .darkening {
                                sleepStepButtonLabel()
                                    .foregroundColor(.primary)
                                    .colorInvert()
                                    .font(.dosIyagiBold(.body))
                                    .lineSpacing(8)
                                    .tracking(-2)
                                    .multilineTextAlignment(.center)
                                    .offset(y: 50)
                            }
                        }
                    
                    Spacer()
                        .frame(maxHeight: 58)
                    
                    if sleepGuideSteps != .darkening {
                        Button {
                            sleepStepSwitcher()
                        } label: {
                            sleepStepButtonLabel()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.primaryButtonBrown)
                                .font(.dosIyagiBold(.body))
                                .tracking(-2)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primaryButtonBrown, lineWidth: 5)
                                }
                        }
                        .background { Color.primaryButtonYellow }
                        .cornerRadius(8)
                        .padding(.vertical, 32)
                        .padding(.horizontal)
                    } else if sleepGuideSteps == .darkening {
                        // - !!!: 상단의 알 Position이 차지할 수 있는 available Space를 제한하기 위한 Spacer
                        Spacer()
                            .frame(maxHeight: 75)
                    }
                }
                
                if sleepGuideSteps == .hug {
                    Button {
                        withAnimation {
                            sleepGuideSteps = .start
                        }
                    } label: {
                        Text("다시하기")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.dosIyagiBold(.callout))
                            .underline(true)
                            .tracking(-2)
                    }
                    .frame(
                        maxHeight: .infinity,
                        alignment: .bottom
                    )
                    .animation(.easeInOut(duration: 1.0), value: sleepGuideSteps)
                    .opacity(sleepGuideSteps == .hug ? 1.0 : 0.0)
                }
                
            }
            .onAppear {
                if isSkippedFromInteractionView {
                    sleepGuideSteps = .darkening
                }
            }
            .onChange(of: scenePhase) { newValue in
                if isChangingFromInactiveScene(into: newValue) {
                    navigationManager.viewCycle = .awake
                } else if newValue == .inactive {
                    // 자러 갈 때 .sleeping 처리
                    print("잘 자러갔니?")
                    dailySleepTimeStore.updateDailySleepTimeToNow()
                }
            }
    }
    
    // MARK: Methods
    private func guideHeaderText() -> some View {
        switch sleepGuideSteps {
        case .start:
            return Text("드림에그가 같이\n수면을 도와줄거예요.")
//            return Text("We will help you fall asleep.")
        case .breath:
            return Text("먼저, 알을 쓰다듬으며\n심호흡을 해보세요.")
//            return Text("First, \nTake a deep breath.")
        case .release:
            return Text("태동과 함께\n숨을 고르는 것에\n집중해보세요.")
//            return Text("Slowly relax your whole body.")
        case .hug:
            return Text("잠들기 편한 상태가 되면\n알려주세요.")
//            return Text("Feel your body relaxing and focus.")
        case .darkening:
            return Text("1. 잠금 버튼을 눌러서\n알이 잘 수 있도록 불을 꺼주세요.")
//            return Text("Push the Lock button\nTo incubate the egg.")
        }
    }
    
    private func sleepStepButtonLabel() -> some View {
        switch sleepGuideSteps {
        case .start:
            return Text("네!")
//            return Text("Yes!")
        case .breath:
            return Text("후- 하-")
//            return Text("Inhale- Exhale-")
        case .release:
            return Text("...")
        case .hug:
            return Text("이제 잘 준비가 됐어요!")
//            return Text("I'll go to sleep now.")
        case .darkening:
            return Text("2. 베개 밑에 알을 품고\n아침에 살피러 와주세요.")
//            return Text("Incubate the egg below the Pillow\nAnd comeback tomorrow morning.")
        }
    }
    
    private func sleepStepSwitcher() {
        switch sleepGuideSteps {
        case .start:
            withAnimation {
                sleepGuideSteps = .breath
            }
        case .breath:
            withAnimation {
                sleepGuideSteps = .release
            }
        case .release:
            withAnimation {
                sleepGuideSteps = .hug
            }
        case .hug:
            withAnimation {
                sleepGuideSteps = .darkening
            }
            
        case .darkening:
            print()
        }
    }
    
    private func isChangingFromInactiveScene(into newScene: ScenePhase) -> Bool {
        scenePhase == .inactive && newScene == .active ||
        scenePhase == .background && newScene == .active
    }
    
    private func isChangingFromActiveScene(into newScene: ScenePhase) -> Bool {
        scenePhase == .active && newScene == .background ||
        scenePhase == .active && newScene == .inactive
    }
}

struct LofiSleepGuideView_Previews: PreviewProvider {
    static var previews: some View {
        LofiSleepGuideView(isSkippedFromInteractionView: .constant(true))
            .environmentObject(DailySleepTimeStore())
    }
}

