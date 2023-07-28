//
//  LofiNameConfirmView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiNameConfirmView: View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var dreamPetName : String = "쿼카" //TODO: CoreData 연결하기
    @State var isTimePassed = false
    @State var dreamPetImage: String = "Quakka_a" //TODO: CoreData 연결하기
    @Binding var confirmedName: String
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                switchHeaderText(isTimePassed: isTimePassed)
                    .font(.dosIyagiBold(.title))
                    .lineSpacing(10)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 116)
                
                Spacer()
                    .frame(maxHeight: 84)
                
                Image(dreamPetImage)
                    .resizable()
                    .frame(width:250, height: 250)
                
                Spacer()
                    .frame(maxHeight: 125)
                
                if isTimePassed {
                    VStack(spacing: 10) {
                        NavigationLink {
                            ZStack {
                                LofiMainTabView() //TODO: MainTabView 내의 DreamWorldView와 연결하기
                            }
                        } label: {
                            Text("네!")
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
                            ZStack {
                                LofiMainTabView()
                            }
                        } label: {
                            Text("나중에 보러갈게요.")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.subButtonBlue)
                                .font(.dosIyagiBold(.body))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.subButtonBlue, lineWidth: 0)
                                }
                        }
                        .background { Color.subButtonSky }
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .padding(.top, 68)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation() {
                    isTimePassed.toggle()
                }
            }
        }
        .onReceive(timer) { _ in
            changeImage()
        }
    }
    
    /// 일정 시간 이후 HeaderText를 변경하는 함수입니다.
    private func switchHeaderText(isTimePassed: Bool) -> some View {
        if isTimePassed {
            return Text("\"\(dreamPetName)\"를\n보러 가볼까요?")
        }
        else {
            return Text("드림펫에게\n\"\(dreamPetName)\"라는\n이름이 생겼어요!")
        }
    }
    
    /// 드림펫의 호흡 애니메이션을 구현하기 위한 함수입니다.
    ///  - 총 세 개의 View에서 사용하고 있어서 이를 통합할 수 있는 방법이 있는지 고민해보고 추후에 진행하겠습니다. 
    private func changeImage() {
            if dreamPetImage[dreamPetImage.index(before: dreamPetImage.endIndex)] == "a" {
            dreamPetImage.remove(at:dreamPetImage.index(before: dreamPetImage.endIndex))
            dreamPetImage.append("b")
        }
        else {
            dreamPetImage.remove(at:dreamPetImage.index(before: dreamPetImage.endIndex))
            dreamPetImage.append("a")
        }
    }
}

struct LofiNameConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        LofiNameConfirmView(confirmedName: .constant(""))
    }
}
