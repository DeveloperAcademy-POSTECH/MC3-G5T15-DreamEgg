//
//  DEButton.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/27.
//

import SwiftUI

enum DEButtonStyle {
    case primaryButton(isDisabled: Bool)
    case subButton(isDisabled: Bool)
}

struct DEButton {
    struct CustomButtonView<CustomLabelType: View>: View {
        let style: DEButtonStyle
        let action: () -> Void
        let label: CustomLabelType?
        
        var body: some View {
            switch style {
            case .primaryButton(let isDisabled):
                Button(action: action) {
                    if let label {
                        label
                            .modifier(DEButtonStyleModifiers(style: style))
                    }
                }
                .disabled(isDisabled)
            case .subButton(let isDisabled):
                Button(action: action) {
                    if let label {
                        label
                            .modifier(DEButtonStyleModifiers(style: style))
                    }
                }
                .disabled(isDisabled)
            }
        }
        init(
            style: DEButtonStyle,
            action: @escaping () -> Void,
            @ViewBuilder label: () -> CustomLabelType
        ) {
            self.style = style
            self.action = action
            self.label = label()
        }
    }
}

public struct DEButtonStyleModifiers: ViewModifier {
    let style: DEButtonStyle

    public func body(content: Content) -> some View {
        switch style {
        case let .primaryButton(isDisabled):
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
                .cornerRadius(8)
                .opacity(isDisabled ? 0.3 : 1.0)
            
            
        case let .subButton(isDisabled):
                content
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(.subButtonBlue)
                    .font(.dosIyagiBold(.body))
                    .background { Color.subButtonSky }
                    .cornerRadius(8)
                    .opacity(isDisabled ? 0.3 : 1.0)
        }
    }
}

struct testView: View {
    @State private var isDisabled = false
    @State private var test = ""
    
    var body: some View {
        VStack {
            TextField(text: $test) {
                Text("testView 입니다.")
            }.padding()
            DEButton.CustomButtonView(
                style: .primaryButton(isDisabled: test.isEmpty))
            {
                print()
            } label: {
                VStack {
                   Text("로그인")
                }
            }
            DEButton.CustomButtonView(
                style: .subButton(isDisabled: isDisabled))
            {
                print()
            } label: {
                VStack {
                   Text("로그인")
                }
            }            
        }.padding()
    }
}

struct DEButton_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
