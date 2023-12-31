//
//  LofiEggInteractionView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/24.
//

import SwiftUI

struct LofiEggInteractionView: View {
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    @StateObject private var eggAnimation = EggAnimation()
    @State private var titleArray = ["알이 생겼어요!\n한번 쓰다듬어보세요.","안에서 움직이는 것 같아요!\n자기 전에 오늘 품을 알을\n맘껏 쓰다듬어주세요.","이제 알을 품기 위해\n잘 시간이군요.\n오늘 수면을 도와드릴까요?"]
    @State private var titleCount = 0
    @State private var isShowButton = false
    @State private var isSkip = false
    @State private var isShowInfo = false
    @State private var isRunInfoAnimation = true
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Spacer()
                    .frame(maxHeight: 72)
                Text(titleArray[titleCount])
                    .multilineTextAlignment(.center)
                    .font(.dosIyagiBold(.title))
                    .foregroundColor(.white)
                    .lineSpacing(16)
                    .frame(maxHeight: 120)
                Spacer()
                    .frame(maxHeight: 65)
                ZStack {
                    Image("EggPillow")
                        .resizable()
                        .frame(width: 246, height: 246)
                        .offset(y:158)

                    Image("\(dailySleepTimeStore.currentDailySleep?.eggName ?? Constant.Errors.NO_EGG)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .rotationEffect(eggAnimation.rotationAngle, anchor: .bottom)
                        .gesture(eggAnimation.dragGesture())
                        .simultaneousGesture(TapGesture().onEnded {
                            if titleCount < 2 {
                                titleAnimation()
                            }
                        })
                        .animation(Animation.easeInOut(duration: 1.0), value: eggAnimation.rotationAngle)
                        .onAppear {
                            eggAnimation.amplitude = 10.0
                            eggAnimation.startPendulumAnimation()
                        }
                }
                Spacer()
                    Text("알을 탭해서 다음으로 진행해주세요.")
                        .font(.dosIyagiBold(.callout))
                        .foregroundColor(.white.opacity(0.6))
                        .opacity(isShowInfo ? 0.8 : 0)
                        .opacity(isRunInfoAnimation ? 0.8 : 0.3)
                NavigationLink(destination: LofiSleepGuideView( isSkippedFromInteractionView:$isSkip).navigationBarBackButtonHidden(true)) {
                    Text("네, 도움이 필요해요.")
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
                .padding(.horizontal)
                .opacity(isShowButton ? 1.0 : 0)
                NavigationLink(destination: LofiSleepGuideView( isSkippedFromInteractionView:$isSkip).navigationBarBackButtonHidden(true)) {
                    Text("아니요, 바로 잘래요.")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(.subButtonBlue)
                        .font(.dosIyagiBold(.body))
                }
                .simultaneousGesture(TapGesture().onEnded{
                    isSkip = true
                })
                .background { Color.subButtonSky }
                .cornerRadius(8)
                .padding(.horizontal)
                .opacity(isShowButton ? 1.0 : 0)
            }
        }
        .onAppear {
            infoAnimation()
        }
    }
    
    private func titleAnimation() {
        withAnimation(Animation.easeInOut(duration: 1.0)) {
            titleCount += 1
            if titleCount == 2 {
                isShowButton = true
            }
        }
    }
    
    private func infoAnimation() {
        if !isShowInfo {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(Animation.easeInOut(duration: 0.8)) {
                    isShowInfo = true
                    infoAnimation()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(Animation.easeInOut(duration: 1.0)) {
                    if titleCount < 1 {
                        isRunInfoAnimation.toggle()
                        infoAnimation()
                    } else {
                        isShowInfo = false
                    }
                }
            }
        }
    }
}

struct LofiEggInteractionView_Previews: PreviewProvider {
    static var previews: some View {
        LofiEggInteractionView()
    }
}
