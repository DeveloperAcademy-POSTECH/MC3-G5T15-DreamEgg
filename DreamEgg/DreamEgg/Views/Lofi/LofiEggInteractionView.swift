//
//  LofiEggInteractionView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/24.
//

import SwiftUI

struct LofiEggInteractionView: View {
    @StateObject private var eggAnimation = EggAnimation.shared
    @State private var interactionTitle = "알이 생겼어요!\n한 번 쓰다듬어볼까요?"
    @State private var isShowButton = false

    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Spacer()
                    .frame(maxHeight: 72)
                
                Text(interactionTitle)
                    .multilineTextAlignment(.center)
                    .font(.dosIyagiBold(.title))
                    .foregroundColor(.white)
                    .lineSpacing(12)
                    .frame(maxHeight: 120)
                Spacer()
                    .frame(maxHeight: 65)
                ZStack {
                    Image("samplePillow")
                        .offset(x:0,y:160)
                    Image("BinyEgg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .rotationEffect(eggAnimation.rotationAngle, anchor: .bottom)
                        .gesture(eggAnimation.dragGesture())
                        .animation(Animation.easeInOut(duration: 1.0), value: eggAnimation.rotationAngle)
                        .onAppear {
                            eggAnimation.startPendulumAnimation()
                            titleAnimation()
                        }
                }
                Spacer()
                
                NavigationLink(destination: LofiSleepGuideView()) {
                    Text("저 좀 재워주세요!")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(.primaryButtonBrown)
                        .font(.dosIyagiBold(.body))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primaryButtonBrown, lineWidth: 5)
                        }
                }
                .navigationBarBackButtonHidden()
                .background { Color.primaryButtonYellow }
                .cornerRadius(8)
                .padding(.horizontal)
                .opacity(isShowButton ? 1.0 : 0)
                NavigationLink(destination: LofiSleepGuideView()) {
                    Text("네, 바로 잘래요.")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(.subButtonBlue)
                        .font(.dosIyagiBold(.body))
                }
                .background { Color.subButtonSky }
                .cornerRadius(8)
                .padding(.horizontal)
                .opacity(isShowButton ? 1.0 : 0)
                .navigationBarBackButtonHidden()
            }
        }
    }
    
    private func titleAnimation() {
//        guard eggAnimation.isDrag else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(Animation.easeInOut(duration: 0.8)) {
                interactionTitle = "알의 움직임이\n느껴지는 것 같아요..!"
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(Animation.easeInOut(duration: 0.8)) {
                interactionTitle = "이제 곧 알을\n품어야 할 시간이에요.\n잠들 준비가 되셨나요?"
                isShowButton = true
            }
        }
    }
}

struct LofiEggInteractionView_Previews: PreviewProvider {
    static var previews: some View {
        LofiEggInteractionView()
    }
}
