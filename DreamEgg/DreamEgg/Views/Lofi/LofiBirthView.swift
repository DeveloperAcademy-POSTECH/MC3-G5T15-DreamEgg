//
//  LofiBirthView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/25.
//

import SwiftUI

struct LofiBirthView: View {
    @frozen enum DreamPetBirthSteps {
        case start
        case exclamationMark
        case justBeforeBirth
        case birth
        case end
    }
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var dreamPetBirthSteps: DreamPetBirthSteps = .start
    @State var dreamCreatureImage : String = "FerretEgg" // TODO: 현재 임의의 이미지를 넣어두었습니다.
    @State var opacityForFadeOut : Double = 0
    @State var isVibrationStarted = false
    @State var isButtonDisabled = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack(spacing: 15) {
                switchHeaderTextByStep()
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .frame(maxHeight: 150)
                
                if dreamPetBirthSteps == .start {
                    Text("알을 탭해주세요.")
                        .font(.dosIyagiBold(.body))
                        .opacity(0.5)
                }
                else {
                    Spacer()
                        .frame(maxHeight:10)
                }
                
                ZStack {
                    Image("beenzinoBreathIn") // TODO: 베개 이미지가 아직 존재하지 않아 임의의 이미지를 넣어두었습니다.
                        .resizable()
                        .frame(width: 200, height: 100)
                        .padding(.top,200)

                    Button(action: {
                        switchDreamPetBirthStep()
                    }){
                        Image(dreamCreatureImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 250, maxHeight: 250)
                            .offset(x: isVibrationStarted ? 0 : 5)
                    }
                    .disabled(isButtonDisabled)
                }
                
                if dreamPetBirthSteps == .end {
                    VStack {
                        NavigationLink {
                            LofiCreatureNamingView()
                        } label: {
                            Text("이름을 지어주자")
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
                        
                        NavigationLink {
                            LofiNameConfirmView()
                        } label: {
                            Text("건너뛰기")
                                .foregroundColor(.subButtonSky)
                                .font(.dosIyagiBold(.callout))
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal)
                    }
                }
                else {
                    Spacer()
                        .frame(maxHeight: 120)
                        .opacity(0)
                }
            }
            .padding(.top, 5)
            .frame(maxHeight: .infinity)

            Rectangle()
                .foregroundColor(.white.opacity(opacityForFadeOut))
                .ignoresSafeArea()
        }
        .onReceive(timer) { _ in
            if dreamPetBirthSteps == .birth || dreamPetBirthSteps == .end {
                changeImage()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    
    /// DreamPetBirthView의 라벨링을 순서에 맞게 변경하는 함수입니다.
    /// - Returns: 순서에 맞는 내용의 Text()를 return 합니다.
    private func switchHeaderTextByStep() -> some View {
        switch dreamPetBirthSteps {
        case .start:
            return Text("지난 밤 동안\n알에 변화가 생겼어요.\n한번 살펴볼까요?")
        case .exclamationMark:
            return Text("..!")
        case .justBeforeBirth:
            return Text("알이 부화하려하나봐요..!")
        case .birth:
            return Text("알에서\n드림펫이 태어났어요!")
        case .end:
            return Text("태어난 드림펫은\n드림월드에서\n볼 수 있어요!")
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
                dreamCreatureImage = "Quakka_a" // TODO: 현재 임의의 데이터를 넣어두었습니다.
                dreamPetBirthSteps = .birth
                withAnimation(.easeIn(duration: 1.0)) {
                    opacityForFadeOut = 0.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation() {
                    dreamPetBirthSteps = .end
                    isButtonDisabled = true
                }
            }
            
        default:
            print("")
        }
    }
    
    
    /// 드림펫이 탄생했을 때, 호흡 애니메이션을 구현하기 위한 함수입니다.
    /// - 기존의 MapViewStore에 존재하는 함수와 동일한 함수이기 때문에 여러 방법을 고민해봤지만, 마땅한 방법을 생각하지 못하고 현재 뷰에 추가해주었습니다.
    private func changeImage() {
        if dreamCreatureImage[dreamCreatureImage.index(before: dreamCreatureImage.endIndex)] == "a" {
            dreamCreatureImage.remove(at:dreamCreatureImage.index(before: dreamCreatureImage.endIndex))
            dreamCreatureImage.append("b")
        }
        else {
            dreamCreatureImage.remove(at:dreamCreatureImage.index(before: dreamCreatureImage.endIndex))
            dreamCreatureImage.append("a")
        }
    }
}

struct LofiBirthView_Previews: PreviewProvider {
    static var previews: some View {
        LofiBirthView()
    }
}
