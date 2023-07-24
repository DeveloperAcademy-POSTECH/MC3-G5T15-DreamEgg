//
//  DreamEggApp.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import SwiftUI

@main
struct DreamEggApp: App {
    @StateObject private var coreDataStore = DailySleepTimeStore(
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
            }
        }
    }
}
