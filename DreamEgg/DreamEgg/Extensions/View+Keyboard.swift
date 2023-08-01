//
//  View+Keyboard.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/29.
//

import SwiftUI

/// 빈 View를 탭하면 키보드가 내려갑니다.
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

