//
//  Color+Palette.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/14.
//

import SwiftUI

extension Color {
    // MARK: Hex Init
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    // MARK: Gradients
    static var dreamPurple: Self {
        .init(hex: "#A092C8")
    }
    
    static var eggViolet: Self {
        .init(hex: "#7785D0")
    }
    
    static var dreamSky: Self {
        .init(hex: "#A3CDFF")
    }
    
    static var eggYellow: Self {
        .init(hex: "#FFCB45")
    }
    
    static var characterFaceBackground: Self {
        .init(hex: "#FFEBB7")
    }
    
    // MARK: Buttons
    static var primaryButtonYellow: Self {
        .init(hex: "#F7D25C")
    }
    
    static var primaryButtonBrown: Self {
        .init(hex: "#8A6F30")
    }
    
    static var subButtonSky: Self {
        .init(hex: "#E7EEFE")
    }
    
    static var subButtonBlue: Self {
        .init(hex: "#639BFF")
    }
}

// MARK: Preview
struct Color_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LinearGradient(
                colors: [
                .dreamPurple,
                .eggViolet
            ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            LinearGradient(
                colors: [
                .dreamSky,
                .eggYellow
            ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Color.characterFaceBackground
            
            Color.primaryButtonBrown
            Color.primaryButtonYellow
            
            Color.subButtonSky
            Color.subButtonBlue
        }
    }
}
