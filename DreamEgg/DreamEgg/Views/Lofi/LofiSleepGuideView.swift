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
    @State private var labelDelayTime: Double = 2.0
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
                    if sleepGuideSteps != .darkening {
                        guideHeaderText()
                            .font(.dosIyagiBold(.title))
                            .multilineTextAlignment(.center)
                            .lineSpacing(12)
                            .foregroundColor(.primary)
                            .colorInvert()
                            .frame(maxHeight: 200)
                    } else if sleepGuideSteps == .darkening {
                        Text("")
                            .frame(maxHeight: 170)
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
                                        .multilineTextAlignment(.trailing)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(width: 8, height: 88)
                                        .padding(.trailing, 4)
                                }
                            }
                        }
                        .overlay(alignment: .bottom) {
                            if sleepGuideSteps == .darkening {
                                sleepStepButtonLabel()
                                    .foregroundColor(.primary)
                                    .colorInvert()
                                    .font(.dosIyagiBold(.body))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    
                    Spacer()
                    
                    if sleepGuideSteps == .hug {
                        Button {
                            sleepStepSwitcher()
                        } label: {
                            sleepStepButtonLabel()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.primaryButtonBrown)
                                .font(.dosIyagiBold(.body))
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
                        Spacer()
                            .frame(maxHeight: 80)
                    }
                    else {
                        Spacer()
                            .frame(maxHeight: 115)
                    }
                }
                
                if sleepGuideSteps == .hug {
                    Button {
                        withAnimation {
                            sleepGuideSteps = .start
                            labelDelayTime = 2.0
                            repeatLabelChanging()
                        }
                    } label: {
                        Text("다시 하기")
                            .foregroundColor(.subButtonSky)
                            .font(.dosIyagiBold(.callout))
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
                repeatLabelChanging()
            }
            .onChange(of: scenePhase) { newValue in
                if isChangingFromInactiveScene(into: newValue) {
                    dailySleepTimeStore.assignSleepingDailySleep()
                    navigationManager.viewCycle = .awake
                } else if newValue == .background {
                    dailySleepTimeStore.updateDailySleepTimeToNow()
                }
            }
    }
    
    // MARK: Methods
    private func guideHeaderText() -> some View {
        switch sleepGuideSteps {
        case .start:
            return Text("저희가 오늘 수면을 도와드릴게요.")
//            return Text("We will help you fall asleep.")
        case .breath:
            return Text("먼저,\n심호흡을 해보세요.")
//            return Text("First, \nTake a deep breath.")
        case .release:
            return Text("이제 알의 태동을 느껴보며\n온 몸에 힘을 빼보아요.")
//            return Text("Slowly relax your whole body.")
        case .hug:
            return Text("호흡에 집중하면서\n오늘 잠들 준비가 되셨나요?")
//            return Text("Feel your body relaxing and focus.")
        case .darkening:
            return Text("잠금 버튼을 눌러서\n알이 잘 수 있도록 불을 꺼주세요.")
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
            return Text("잘 준비가 된 것 같아요!")
//            return Text("I'll go to sleep now.")
        case .darkening:
            return Text("베개 밑에 알을 품고\n아침에 살피러 와주세요.")
//            return Text("Incubate the egg below the Pillow\nAnd comeback tomorrow morning.")
        }
    }
    
    private func sleepStepSwitcher() {
        switch sleepGuideSteps {
        case .start:
            withAnimation {
                sleepGuideSteps = .breath
                labelDelayTime = 4.0
            }
        case .breath:
            withAnimation {
                sleepGuideSteps = .release
                labelDelayTime = 5.0
            }
        case .release:
            withAnimation {
                sleepGuideSteps = .hug
                labelDelayTime = 5.0
            }
        case .hug:
            withAnimation {
                sleepGuideSteps = .darkening
            }
            
        case .darkening:
            print("SLEEP GUIDE VIEW > LOCK SCREEN")
        }
        repeatLabelChanging()
    }
    
    private func repeatLabelChanging() {
        
        switch sleepGuideSteps
        {
        case .hug:
            return
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + labelDelayTime) {
                sleepStepSwitcher()
            }
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

