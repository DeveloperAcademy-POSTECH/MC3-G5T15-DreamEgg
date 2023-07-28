//
//  DENavigationLink.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/27.
//

import SwiftUI

enum DENavigationLinkStyle {
    case primaryNavigationLink(isDisabled: Bool)
    case subNavigationLink(isDisabled: Bool)
}


struct DENavigationLink<Destination: View, Label: View>: View {
    private(set) var style: DENavigationLinkStyle
    private(set) var destination: Destination
    private(set) var label: Label
    
    var body: some View {
        switch style {
        case .primaryNavigationLink(let isDisabled):
            navigationLinkBuilder(style: style)
                .disabled(isDisabled)
        case .subNavigationLink(let isDisabled):
            navigationLinkBuilder(style: style)
                .disabled(isDisabled)
        }
    }
    init(
        style: DENavigationLinkStyle,
        destination: @escaping () -> Destination,
        label: @escaping () -> Label
    ) {
        self.style = style
        self.destination = destination()
        self.label = label()
    }
    
    @ViewBuilder
    private func navigationLinkBuilder(style: DENavigationLinkStyle) -> some View {
        NavigationLink {
            destination
        } label: {
            label
                .modifier(DENavigationLinkStyleModifiers(style: style))
        }
    }
}

public struct DENavigationLinkStyleModifiers: ViewModifier {
    let style: DENavigationLinkStyle
    
    public func body(content: Content) -> some View {
        switch style {
        case let .primaryNavigationLink(isDisabled):
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
                .opacity(isDisabled ? 0.3 : 1.0)
            
            
        case let .subNavigationLink(isDisabled):
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


struct testView2: View {
    @State private var isDisabled = false
    @State private var test = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField(text: $test) {
                    Text("testView2 입니다.")
                }.padding()
                DENavigationLink(style: .primaryNavigationLink(isDisabled: test.isEmpty)) {
                    LofiEggDrawView()
                } label: {
                    Text("알 그리기 뷰")
                }
                DENavigationLink(style: .subNavigationLink(isDisabled: isDisabled)) {
                    LofiDreamWorldView()
                } label: {
                    Text("드림월드 뷰")
                }
            }.padding()
        }
    }
}

struct DENavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        testView2()
    }
}
