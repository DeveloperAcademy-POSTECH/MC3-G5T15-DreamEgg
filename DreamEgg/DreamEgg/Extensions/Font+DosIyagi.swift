//
//  Font+DosIyagi.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/17.
//

import SwiftUI

extension Font {
    enum DEFontSize: CGFloat {
        case largeTitle = 34
        case title = 28
        case title2 = 22
        case title3 = 20
        case body = 17
        case callout = 16
        case footnote = 13
        case caption = 12
        case caption2 = 11
    }
    
//    @available(*, unavailable, message: "DosPilgi is only in Images")
    static func dosPilgi(_ size: DEFontSize) -> Font {
        custom("DOSPilgi", size: size.rawValue)
    }

    static func dosIyagiBold(_ size: DEFontSize) -> Font {
        custom("DOSIyagiBoldface", size: size.rawValue)
    }
}
