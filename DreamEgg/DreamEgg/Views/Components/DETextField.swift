//
//  DETextField.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/07/25.
//

import SwiftUI

struct DETextField: View {
    @Binding var content: String
    @State var placeholder: String = "입력"
    
    var body: some View {
        TextField(text: $content) {
            Text(placeholder)
        }
        .font(.dosIyagiBold(.body))
        .padding(32)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: 150, maxHeight: 54)
//        .frame(maxWidth: 120, maxHeight: 30)
        .background() {
            Capsule()
                .fill(Color.subButtonSky)
                .shadow(color: .primary.opacity(0.1), radius: 5, y: 5)
        }
        .padding(8)
    }
}

struct DETextField_Previews: PreviewProvider {
    static var previews: some View {
        DETextField(content: Binding.constant(""))
    }
}
