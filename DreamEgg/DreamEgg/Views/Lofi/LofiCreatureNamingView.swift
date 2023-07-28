//
//  LofiCreatureNamingView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiCreatureNamingView: View {
    @State var name: String = ""
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Text("드림펫에게\n새로운 이름을 지어주세요.")
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .padding()
                    .lineSpacing(10)
                
                Spacer()
                    .frame(maxHeight: 145)
                
                HStack {
                    Text("안녕,")
                    
                    // MARK: Design System으로 변경 예정
                    DETextField(style: .nameTextField, content: $name, maxLength: 10)
                    
//                    TextField(text: .constant("")) {
//                        Text("Sammy")
//                    }
//                    .multilineTextAlignment(.center)
//                    .frame(
//                        maxWidth: 125,
//                        maxHeight: 50
//                    )
//                    .background {
//                        Capsule()
//                            .fill(Color.subButtonSky)
//                    }
//                    .padding(8)
                    
                    Text("!")
                }
                .font(.dosIyagiBold(.body))
                
                Spacer()
                    .frame(maxHeight: 24)
                
                Text("이름은 언제든지\n다시 수정할 수 있어요.")
                    .font(.dosIyagiBold(.body))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(maxHeight: 276)
                
                VStack {
                    NavigationLink {
                        LofiNameConfirmView(confirmedName: $name)
                    } label: {
                        Text("이렇게 지을래요.")
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
                }
            }
            .padding(.top,68)
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct LofiCreatureNamingView_Previews: PreviewProvider {
    static var previews: some View {
        LofiCreatureNamingView()
    }
}
