//
//  DreamEggApp.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import SwiftUI

@main
struct DreamEggApp: App {
    @StateObject private var navigationManager = DENavigationManager()
    @StateObject private var dailySleepTimeStore = DailySleepTimeStore(
        coreDataStore: .debugShared
    )
    
    @StateObject private var userSleepConfigStore = UserSleepConfigStore(
        coreDataStore: .debugShared
    )
    
    let testing = false

    var body: some Scene {
        WindowGroup {
            if testing {
//                CoreDataTestView()
//                FontTestView()
//                SleepTimeSettingView()
//                DECalendarTestView()
                EggInteractionTestView()
            } else {
                ContentView()
                    .environmentObject(navigationManager)
                    .environmentObject(dailySleepTimeStore)
                    .environmentObject(userSleepConfigStore)
            }
        }
    }
}
