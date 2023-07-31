//
//  DEFontStyle.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/07/30.
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
//        case footnote
//        case caption
//        case caption2
    }
    
    let style: DEFontStyles
    
    @State var text: String = ""
    
    var body: some View {
        switch style {
        case .largeTitle:
            Text(text)
                .font(.dosIyagiBold(.largeTitle))
                .lineSpacing(20)
                .tracking(-2)
            
        case .title:
            Text(text)
                .font(.dosIyagiBold(.title))
                .lineSpacing(16)
                .tracking(-3)
            
        case .title2:
            Text(text)
                .font(.dosIyagiBold(.title2))
                .lineSpacing(16)
                .tracking(-2)
            
        case .title3:
            Text(text)
                .font(.dosIyagiBold(.title3))
                .lineSpacing(16)
                .tracking(-2)
            
        case .body:
            Text(text)
                .font(.dosIyagiBold(.body))
                .lineSpacing(8)
                .tracking(-2)
            
        case .callout:
            Text(text)
                .font(.dosIyagiBold(.callout))
                .lineSpacing(8)
                .tracking(-2)
        }
    }
}

struct fontTestView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 80) {
            DEFontStyle(style: .largeTitle, text: "large Title 텍스트 크기\n자간과 행간, 어때요?!\n24:32/59")
            
            DEFontStyle(style: .title, text: "title 텍스트 크기\n자간과 행간, 어때요?!\n24:32/59")
            
            DEFontStyle(style: .title3, text: "title3 텍스트 크기\n자간과 행간, 어때요?!\n24:32/59")
            
            DEFontStyle(style: .body, text: "body discription 텍스트 크기\n자간과 행간, 어때요?!\n24:32/59")
            
            DEFontStyle(style: .callout, text: "callout 텍스트 크기\n자간과 행간, 어때요?!\n24:32/59")
        }
    }
}

struct DEFontStyleView_Previews: PreviewProvider {
    static var previews: some View {
        fontTestView()
    }
}
