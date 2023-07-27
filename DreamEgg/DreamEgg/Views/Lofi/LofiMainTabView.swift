//
//  LofiMainEggView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI
import Combine

struct LofiMainTabView: View {
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    @State private var tabSelection: Int = 1
    
    var body: some View {
        ZStack {
            if tabSelection == 2 {
                Image("DreamWorldMap")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
            else {
                GradientBackgroundView()
            }

            TabView(selection: $tabSelection) {
                DECalendarTestView()
                    .tag(0)
                    .tabItem {
                        Image("CalendarTabIcon")
                    }
                
                // MARK: Main Egg
                LofiMainEggView()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .tag(1)
                    .tabItem {
                        Image("DreamEggTabIcon")
                    }
                
                LofiDreamWorldView()
                    .tag(2)
                    .tabItem {
                        Image("DreamWorldTabIcon")
                    }
            }
            .tabViewStyle(.page)
        }
        .navigationBarBackButtonHidden()
    }
}

struct LofiMainTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LofiMainTabView()
        }
    }
}
