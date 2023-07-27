//
//  DEButton.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/27.
//

import SwiftUI

enum DEButtonStyle {
    case primaryButton
    case subButton
}

enum DEButtonState {
    case enabled
    case disabled
}

public struct DEButtonStyleModifiers: ViewModifier {
    let style: DEButtonStyle
    let state: DEButtonState
    
    public func body(content: Content) -> some View {
        switch style {
        case .primaryButton:
            switch state {
            case .enabled:
                content
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(.primaryButtonBrown)
                    .font(.dosIyagiBold(.body))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primaryButtonBrown, lineWidth: 4)
                    }
                    .background { Color.primaryButtonYellow }
            case .disabled:
                content
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(.primaryButtonBrown)
                    .font(.dosIyagiBold(.body))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primaryButtonBrown, lineWidth: 4)
                    }
                    .background { Color.primaryButtonYellow }
                    .opacity(0.3)
            }
        case .subButton:
            switch state {
            case .enabled:
                content
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(.subButtonBlue)
                    .font(.dosIyagiBold(.body))
                    .background { Color.subButtonSky }
                    .cornerRadius(8)
            case .disabled:
                content
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(.subButtonBlue)
                    .font(.dosIyagiBold(.body))
                    .background { Color.subButtonSky }
                    .cornerRadius(8)
                    .opacity(0.3)
            }
        }
    }
}

struct testView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: LofiEggDrawView()) {
                Text("NavigationLink primaryButton enabled")
                    .modifier(DEButtonStyleModifiers(style: .primaryButton, state: .enabled))
            }
            
            Button {
            } label: {
                Text("primaryButton disabled")
                    .modifier(DEButtonStyleModifiers(style: .primaryButton, state: .disabled))
            }
            Button {
            } label: {
                Text("subButton enabled")
                    .modifier(DEButtonStyleModifiers(style: .subButton, state: .enabled))
            }
            Button {
            } label: {
                Text("subButton enabled")
                    .modifier(DEButtonStyleModifiers(style: .subButton, state: .disabled))
            }
        }
    }
}

struct DEButton_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
