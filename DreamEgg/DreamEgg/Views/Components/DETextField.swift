//
//  DETextField.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/07/25.
//

import SwiftUI

struct DETextField: View {
    enum DETextFieldStyle {
        case nameTextField
        case messageTextField
    }
    
    let style: DETextFieldStyle
    
    @Binding var content: String
    @State var placeholder: String = "입력"
//    @State var isMessageTextField: Bool = false
    var maxLength: Int
    
    var body: some View {
        switch style {
        case .nameTextField:
            VStack {
                TextField(text: $content) {
                    Text(placeholder)
                }
                .onChange(of: content) {
                     newValue in
                    /// 글자 수가 maxLength를 초과하면 제한합니다.
                    /// prefix는  maxLength까지의 글자까지만 보여줍니다.
                    if content.count > maxLength {
                        content = String(content.prefix(maxLength))
                    }
                }
                .font(.dosIyagiBold(.body))
                .tracking(-1)
                .padding(32)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: 150, maxHeight: 54)
                .background() {
                    Capsule()
                        .fill(Color.subButtonSky)
                        .shadow(color: .primary.opacity(0.1), radius: 5, y: 5)
                }
                .padding(8)
            }
            
        case .messageTextField:
            VStack(alignment: .center) {
                TextField(text: $content) {
                    Text(placeholder)
                }
                .onChange(of: content) {
                     newValue in
                    /// 글자 수가 maxLength를 초과하면 제한합니다.
                    /// prefix는  maxLength까지의 글자까지만 보여줍니다.
                    if content.count > maxLength {
                        content = String(content.prefix(maxLength))
                    }
                }
                .font(.dosIyagiBold(.body))
                .tracking(-1)
                .padding(32)
                /// 클리어 버튼과 text 입력 영역이 겹치지 않도록 추가 패딩값을 줬습니다.
                .padding(.trailing, 18)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: 320, maxHeight: 54)
                .background() {
                    Capsule()
                        .fill(Color.subButtonSky)
                        .shadow(color: .primary.opacity(0.1), radius: 5, y: 5)
                }
                /// 클리어 버튼을 추가했습니다.
                .overlay {
                    if !content.isEmpty {
                        Button(action: {
                            content = ""
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.secondary)
                                .frame(width: 22, height: 22)
                        }
                        .position(x: 288, y: 27)
                    }
                }
                .padding(8)
                
                    /// 입력된 글자 수를 count하는 텍스트를 추가했습니다.
                HStack {
                    Text("\(content.count)")
                        .foregroundColor(content.count >= maxLength ? .white : .white.opacity(0.6))
                    Text("/\(maxLength)")
                        .foregroundColor(.white)
                }
                .font(.dosIyagiBold(.callout))
            }
        }
    }
}

struct DETextField_Previews: PreviewProvider {
    static var previews: some View {
        DETextField(style: .messageTextField, content: Binding.constant(""), maxLength: 30)
    }
}
