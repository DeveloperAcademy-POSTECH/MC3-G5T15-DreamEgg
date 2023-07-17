//
//  DreamEggApp.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import SwiftUI

@main
struct DreamEggApp: App {
    let testing = true

    var body: some Scene {
        WindowGroup {
            if testing {
//                CoreDataTestView()
                FontTestView()
            } else {
                ContentView()
            }
        }
    }
}
