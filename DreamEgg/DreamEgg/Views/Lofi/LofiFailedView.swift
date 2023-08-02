//
//  LofiFailedView.swift
//  DreamEgg
//
//  Created by SUNGIL-POS on 2023/07/27.
//

import SwiftUI

struct LofiFailedView: View {
    @EnvironmentObject var navigationManager: DENavigationManager
    
    @frozen enum DreamPetFailedSteps {
        case start
        case end
    }
    @State private var dreamPetFailedSteps: DreamPetFailedSteps = .start
    @State var dreamCreatureImage : String = "FerretEgg" // TODO: 현재 임의의 데이터를 넣어두었습니다.
    @State var isButtonsAppear = false
    @State var isEggDisappear = false
    @State var tabSelection: Int = 1
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack(spacing: 96) {
                switchHeaderTextByStep()
                    .font(.dosIyagiBold(.title))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(16)
                    .tracking(-1)
                    .frame(height: 120, alignment: .top)

                Image(dreamCreatureImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 301, maxHeight: 301)
                    .opacity(isEggDisappear ? 0 : 1)
                    .background(
                        Image("EggPillow")
                            .resizable()
                            .frame(width: 246, height: 246)
                            .offset(y:158)
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation() {
                                dreamPetFailedSteps = .end
                            }
                            withAnimation() {
                                isButtonsAppear = true
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeOut(duration: 4.0)) {
                                isEggDisappear = true
                            }
                        }
                    }
                
                if dreamPetFailedSteps == .end {
                    VStack {
//                        Text("꼭 오래 품어주세요!")
//                            .font(.dosIyagiBold(.body))
//                            .opacity(0.5)
                        Spacer()
                            .frame(maxHeight:50)
                        Button {
                            withAnimation {
                                navigationManager.viewCycle = .general
                            }
                        } label: {
                            Text("네!")
                                .font(.dosIyagiBold(.body))
                                .tracking(-1)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.primaryButtonBrown)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primaryButtonBrown, lineWidth: 5)
                                }
                        }
                        .background { Color.primaryButtonYellow }
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                else {
                    Spacer()
                        .frame(maxHeight: 99)
                        .opacity(0)
                }
            }
            .padding(.top, 88)
            .frame(maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden()
    }
    
    
    /// DreamPetBirthView의 라벨링을 순서에 맞게 변경하는 함수입니다.
    /// - Returns: 순서에 맞는 내용의 Text()를 return 합니다.
    private func switchHeaderTextByStep() -> some View {
        switch dreamPetFailedSteps {
        case .start:
            return Text("오늘같이\n잠들기 힘든 날도 있죠.")
        case .end:
            return Text("드림에그는 언제나\n기다리고 있어요.\n내일은 꼭 만나러 와주세요!")
        }
    }
}

struct LofiFailedView_Previews: PreviewProvider {
    static var previews: some View {
        LofiFailedView()
    }
}
