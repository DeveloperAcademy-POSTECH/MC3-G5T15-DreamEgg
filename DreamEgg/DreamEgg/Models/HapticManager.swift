//
//  HapticManager.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/13.
//

import AVFoundation
import Foundation
import UIKit

class HapticManager {
    
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    func avFoundation() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
