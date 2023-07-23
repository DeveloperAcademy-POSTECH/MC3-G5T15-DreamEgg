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
        case starter
        case timeSetting
        case general
    }
    
    @Published var starterPath = [Date]()
    @Published var viewCycle: DEViewCycle = .splash
    
    // MARK: Methods
    public func resetSleepTime() {
        self.viewCycle = .timeSetting
    }
    
    public func authenticateUserIntoGeneralState() {
        self.viewCycle = .general
    }
    
    public func repeatStarterProcess() {
        self.viewCycle = .starter
    }
}
