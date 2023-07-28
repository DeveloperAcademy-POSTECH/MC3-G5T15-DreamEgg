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
        coreDataStore: .releaseShared
    )
    
    @StateObject private var userSleepConfigStore = UserSleepConfigStore(
        coreDataStore: .releaseShared
    )
    
    @StateObject private var localNotificationManager = LocalNotificationManager()
    
    let testing = false

    var body: some Scene {
        WindowGroup {
            if testing {
//                CoreDataTestView()
//                FontTestView()
//                SleepTimeSettingView()
//                DECalendarTestView()
//                EggInteractionTestView()
                // LocalNotificationView()
//                DETextField(style: .messageTextField, content: "")
//                LofiTextCustomView()
                LofiCreatureNamingView()
//                CreatureDetailView()
                
            } else {
                ContentView()
                    .environmentObject(navigationManager)
                    .environmentObject(dailySleepTimeStore)
                    .environmentObject(userSleepConfigStore)
                    .environmentObject(localNotificationManager)
            }
        }
    }
}
