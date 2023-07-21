//
//  LofiTextCustomView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/19.
//

import SwiftUI

struct LofiTextCustomView: View {
    @State private var notificationMessage: String = ""
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 75)
                
                VStack {
//                    Text("내일 나에게 할 말을 \n적어주세요")
                    Text("Write down what you will say to tomorrow's me")
                        .font(.dosIyagiBold(.title))
                        .lineSpacing(12)
                        .padding()
                    
//                    Text("기존 알림 대신에 적어주신 문장으로 알림을 드릴게요!")
                    Text("We will notify you with the words.")
                        .font(.dosIyagiBold(.body))
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                
                Spacer()
                
                HStack {
//                    Text("내일은")
                    Text("Tomorrow I will")
                    
                    // MARK: Design System으로 변경 예정
                    TextField(text: $notificationMessage) {
                        Text("Swim")
                    }
                    .multilineTextAlignment(.center)
                    .frame(
                        maxWidth: 125,
                        maxHeight: 50
                    )
                    .background {
                        Capsule()
                            .fill(Color.subButtonSky)
                    }
                    .padding(8)
                    
//                    Text("하는 날!")
                }
                .font(.dosIyagiBold(.body))
                
                Spacer()
                
                NavigationLink {
//                    MainEggsView(countDown: 1000)
                    LofiMainEggView()
                } label: {
//                    Text("이렇게 알림을 보내주세요")
                    Text("Notify me with that")
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
                .padding()
                
                NavigationLink {
//                    MainEggsView(countDown: 1000)
                    LofiMainEggView()
                } label: {
//                    Text("건너뛰기")
                    Text("Skip")
                        .foregroundColor(.subButtonSky)
                        .font(.dosIyagiBold(.callout))
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct LofiTextCustomView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LofiTextCustomView()
        }
    }
}
