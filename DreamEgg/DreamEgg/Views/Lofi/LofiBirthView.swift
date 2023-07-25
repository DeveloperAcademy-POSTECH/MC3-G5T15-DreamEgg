//
//  LofiBirthView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/25.
//

import SwiftUI

struct LofiBirthView: View {
    let labelingArr : [String] = [
        "지난 밤 동안\n알에 변화가 생겼어요.\n한번 살펴볼까요?",
        "...!",
        "알이 부화하려하나봐요..!",
        "알에서\n드림펫이 태어났어요!",
    ]
    @State var  imageName : String = "FerretEgg"
    @State var i : Int = 0
    @State var gradientOpacity : Double = 0
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Text(labelingArr[i])
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .frame(maxHeight: 200)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)) {
                            
                        }
                    }
                
                Text("알을 탭해주세요.")
                    .font(.dosIyagiBold(.title2))

                ZStack {
                    Image("beenzinoBreathIn")
                        .resizable()
                        .frame(width: 200, height: 100)
                        .padding(.top,200)
                    
                    
                    Button(action: {
                        if i < 2 {
                            i += 1
                        }
                        else if i == 2 {
                            withAnimation(.easeOut(duration: 1.0)) {
                                gradientOpacity = 1.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                imageName = "Quakka_a"
                                i += 1
                                withAnimation(.easeIn(duration: 1.0)) {
                                    gradientOpacity = 0.0
                                }
                            }
                                
                        }
                    }){
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 250, maxHeight: 250)
                    }
                    
                }
            }
            
            Rectangle()
                .foregroundColor(.white.opacity(gradientOpacity))
                .ignoresSafeArea()
        }
    }
}

struct LofiBirthView_Previews: PreviewProvider {
    static var previews: some View {
        LofiBirthView()
    }
}
