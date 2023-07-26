//
//  NameEditingView.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/07/25.
//

import SwiftUI

struct NameEditingView: View {
    @State var editedName: String = ""
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                
                Text("드림펫의 이름을 \n바꾸시겠어요?")
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                    .frame(maxHeight: 125)
                
                HStack {
                    Text("안녕,")
                    
                    DETextField(content: $editedName)
                    
                    Text("!")
                }
                .font(.dosIyagiBold(.body))
                
                Spacer()
                
                VStack {
                    NavigationLink {
                        CreatureDetailView()
                    } label: {
                        Text("이렇게 바꿀게요.")
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
                .frame(
                    maxHeight: .infinity,
                    alignment: .bottom
                )

            }
        }
    }
}

struct NameEditingView_Previews: PreviewProvider {
    static var previews: some View {
        NameEditingView()
    }
}

// UX적으로 depth가 커지는 뷰 추가문제로 해당 뷰는 사용하지 않습니다.
