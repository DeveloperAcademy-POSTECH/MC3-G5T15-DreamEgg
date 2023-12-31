//
//  LofiBirthView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/25.
//

import Combine
import SwiftUI

struct LofiBirthView: View {
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    
    @frozen enum DreamPetBirthSteps {
        case start
        case exclamationMark
        case justBeforeBirth
        case birth
        case end
    }
    
    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common)
    @State private var timerCancellable: Cancellable?
    
    @State private var dreamPetBirthSteps: DreamPetBirthSteps = .start
    @State var dreampetEggName: String = ""
    @State var dreampetAssetName: String = ""
    
    @State var opacityForFadeOut : Double = 0
    @State var isVibrationStarted = false
    @State var isButtonDisabled = false
    
    var body: some View {
        ZStack(alignment: .top) {
            GradientBackgroundView()
            
            VStack(spacing: 24) {
                switchHeaderTextByStep()
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .lineSpacing(16)
                    .frame(minHeight: 116)
                
                if dreamPetBirthSteps == .start {
                    Text("알을 탭해주세요.")
                        .font(.dosIyagiBold(.body))
                        .opacity(0.5)
                }
                else {
                    Text(" ")
                }
                
                Button {
                    switchDreamPetBirthStep()
                } label: {
                    Image(getDreampetImageName())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 301, maxHeight: 301)
                        .offset(x: isVibrationStarted ? 0 : 5)
                        .background(
                                Image("EggPillow")
                                    .resizable()
                                    .frame(maxWidth: 246, maxHeight: 246)
                                    .offset(y:162)
                                    .opacity(CheckStepIsBirthOrend(step: dreamPetBirthSteps))
                        )
                }
                .disabled(isButtonDisabled)
                
                if dreamPetBirthSteps == .end {
                    VStack(spacing: 10) {
                        NavigationLink {
                            LofiCreatureNamingView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("이름을 지어줄래요.")
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
                        .navigationBarBackButtonHidden()
                        
                        NavigationLink {
                            LofiNameConfirmView()
                        } label: {
                            Text("건너뛰기")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.subButtonBlue)
                                .font(.dosIyagiBold(.body))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.subButtonSky, lineWidth: 5)
                                }
                        }
                        .background { Color.subButtonSky }
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    .padding(.top, 65)
                }
            }
            .padding(.top, 74)

            Rectangle()
                .foregroundColor(.white.opacity(opacityForFadeOut))
                .ignoresSafeArea()


        }
        .onReceive(timer) { _ in
            if dreamPetBirthSteps == .birth || dreamPetBirthSteps == .end {
                changeImage()
            }
        }
        .onAppear {
            self.dreampetEggName = dailySleepTimeStore.currentDailySleep?.eggName ?? "NOEGG!!"
            self.dreampetAssetName = dailySleepTimeStore.getAssetNameSafely()
            self.timerCancellable = self.timer.connect()
        }
        .onDisappear {
            self.timerCancellable?.cancel()
        }
        .navigationBarBackButtonHidden()
    }
    
    
    /// DreamPetBirthView의 라벨링을 순서에 맞게 변경하는 함수입니다.
    /// - Returns: 순서에 맞는 내용의 Text()를 return 합니다.
    private func switchHeaderTextByStep() -> some View {
        switch dreamPetBirthSteps {
        case .start:
            return Text("밤 동안 드림에그에\n변화가 생겼어요.\n한번 살펴볼까요?")
        case .exclamationMark:
            return Text("..!")
        case .justBeforeBirth:
            return Text("알이 부화하려고해요..!")
        case .birth:
            return Text("알에서\n드림펫이 태어났어요!")
        case .end:
            return Text("드림펫의 이름을\n지어줄 수 있어요.")
        }
    }
    
    /// 사용자의 버튼 액션에 따라 DreamPetBirthView의 순서를 변경해주는 함수입니다.
    private func switchDreamPetBirthStep() {
        switch dreamPetBirthSteps {
        case .start:
            withAnimation {
                dreamPetBirthSteps = .exclamationMark
            }
            HapticManager.instance.avFoundation()
            withAnimation(.easeOut(duration: 0.1).repeatCount(6, autoreverses: true)) {
                self.isVibrationStarted.toggle()
            }
            
        case .exclamationMark:
            withAnimation {
                dreamPetBirthSteps = .justBeforeBirth
            }
            HapticManager.instance.avFoundation()
            withAnimation(.easeOut(duration: 0.1).repeatCount(6, autoreverses: true)) {
                self.isVibrationStarted.toggle()
            }
            
        case .justBeforeBirth:
            withAnimation(.easeOut(duration: 1.0)) {
                opacityForFadeOut = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dreampetAssetName = "\(dreampetAssetName)_a"
                isButtonDisabled = true
                dreamPetBirthSteps = .birth
                withAnimation(.easeIn(duration: 1.0)) {
                    opacityForFadeOut = 0.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation() {
                    dreamPetBirthSteps = .end
                }
            }
            
        default:
            print("BIRTH_VIEW_DEFAULT")
        }
    }
    
    
    /// 드림펫이 탄생했을 때, 호흡 애니메이션을 구현하기 위한 함수입니다.
    /// - 기존의 MapViewStore에 존재하는 함수와 동일한 함수이기 때문에 여러 방법을 고민해봤지만, 마땅한 방법을 생각하지 못하고 현재 뷰에 추가해주었습니다.
    private func changeImage() {
        if dreampetAssetName[dreampetAssetName.index(before: dreampetAssetName.endIndex)] == "a" {
            dreampetAssetName.remove(at:dreampetAssetName.index(before: dreampetAssetName.endIndex))
            dreampetAssetName.append("b")
        } else {
            dreampetAssetName.remove(at:dreampetAssetName.index(before: dreampetAssetName.endIndex))
            dreampetAssetName.append("a")
        }
    }
    
    private func CheckStepIsBirthOrend(step: DreamPetBirthSteps) -> Double {
        if step == .birth || step == .end {
            return 0
        }
        else {
            return 1
        }
    }
    
    private func getDreampetImageName() -> String {
        dreamPetBirthSteps == .birth || dreamPetBirthSteps == .end
            ? dreampetAssetName
            : dreampetEggName
    }
}

struct LofiBirthView_Previews: PreviewProvider {
    static var previews: some View {
        LofiBirthView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE(3rd generation)"))
            .previewDisplayName("iPhone SE(3rd generation)")
        LofiBirthView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
        LofiBirthView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("iPhone 14 Pro Max")
    }
}
