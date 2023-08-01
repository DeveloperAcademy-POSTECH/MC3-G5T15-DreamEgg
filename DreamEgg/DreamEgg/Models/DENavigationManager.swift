//
//  DENavigationManager.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/23.
//

import SwiftUI

final class DENavigationManager: ObservableObject {
    enum DEViewCycle: String {
        case splash
        case notificationMessageSetting
        case timeSetting
        case timeReset
        case general
        case awake
        case drawEgg
    }
    
    @Published var starterPath = [Date]()
    @Published var isFromMainTab: Bool = false
    @Published var viewCycle: DEViewCycle = .splash
    
    // MARK: Methods    
    public func authenticateUserIntoGeneralState() {
        self.viewCycle = .general
    }
    
    public func navigateToTimeSettingView() {
        self.viewCycle = .timeSetting
    }
}
