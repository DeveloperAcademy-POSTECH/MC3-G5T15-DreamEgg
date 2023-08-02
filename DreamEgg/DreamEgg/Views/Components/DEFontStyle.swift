//
//  DEFontStyle.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/08/02.
//

import SwiftUI

struct DEFontStyle: View {
    enum DEFontStyles {
        case largeTitle
        case title
        case title2
        case title3
        case body
        case callout
        case footnote
    }
    
    let style: DEFontStyles
    
    @State var text: String = ""
    
    var body: some View {
        switch style {
        case .largeTitle:
            Text(text)
                .font(.dosIyagiBold(.largeTitle))
                .lineSpacing(20)
                .tracking(-1)
            
        case .title:
            Text(text)
                .font(.dosIyagiBold(.title))
                .lineSpacing(16)
                .tracking(-1)
            
        case .title2:
            Text(text)
                .font(.dosIyagiBold(.title2))
                .lineSpacing(12)
                .tracking(-1)
            
        case .title3:
            Text(text)
                .font(.dosIyagiBold(.title3))
                .lineSpacing(12)
                .tracking(-1)
            
        case .body:
            Text(text)
                .font(.dosIyagiBold(.body))
                .lineSpacing(8)
                .tracking(-1)
            
        case .callout:
            Text(text)
                .font(.dosIyagiBold(.callout))
                .lineSpacing(8)
                .tracking(-1)
            
        case .footnote:
            Text(text)
                .font(.dosIyagiBold(.footnote))
                .lineSpacing(8)
                .tracking(-1)
        }
    }
}

struct fontTestView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            DEFontStyle(style: .largeTitle, text: "라지타이틀입니다.\n목표한 수면시간은\n12시 30분이네요.")
            
            DEFontStyle(style: .title, text: "타이틀입니다.\n목표한 수면시간은\n12시 30분이네요.")
            
            DEFontStyle(style: .title2, text: "타이틀2입니다.\n목표한 수면시간은\n12시 30분이네요.")
            
            DEFontStyle(style: .footnote, text: "바디입니다.\n알을 탭해서\n그려주세요.\n건너뛰기")
            
            DEFontStyle(style: .callout, text: "콜아웃입니다.\n8월 15일 출생\n건너뛰기")
        }
        .multilineTextAlignment(.center)
    }
}

struct DEFontStyle_Previews: PreviewProvider {
    static var previews: some View {
        fontTestView()
    }
}
