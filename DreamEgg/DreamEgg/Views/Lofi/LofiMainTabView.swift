//
//  LofiMainEggView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI
import Combine

@frozen enum TabViewSteps {
    case calendar, egg, world
}

struct LofiMainTabView: View {
    @frozen private enum TabViewSteps: Hashable {
        case calendar, egg, world
    }
    
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    @EnvironmentObject var navigationManager: DENavigationManager
    @State var tabSelection: Int = 1
    @State private var isWorldMap: Bool = false
    @State private var tabViewSteps: TabViewSteps = .egg
    
    var body: some View {
        ZStack {
            Image("DreamWorldMap")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .overlay {
                    if isWorldMap {
                        LofiDreamWorldView()
                    }
                }

            GradientBackgroundView()
                .opacity(isWorldMap ? 0.0 : 1.0)

            TabView(selection: $tabViewSteps) {
                DECalendarTestView()
                    .tag(TabViewSteps.calendar)
                    .tabItem {
                        Image("CalendarTabIcon")
                    }

                
                // MARK: Main Egg
                LofiMainEggView()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .tag(TabViewSteps.egg)
                    .tabItem {
                        Image("DreamEggTabIcon")
                    }

                Text("")
                    .tag(TabViewSteps.world)
                    .tabItem {
                        Image("DreamWorldTabIcon")
                    }
            }
            .tabViewStyle(.page)
        }
        .navigationBarBackButtonHidden()
        .background(Color.black)
        .onAppear {
            if navigationManager.isToDreamWorld {
                tabSelection = 2
                navigationManager.isToDreamWorld = false
            }
        }
        .onChange(of: tabViewSteps) { tabViewSteps in
            if tabViewSteps == .world {
                withAnimation(.linear(duration: 0.4)) {
                    self.isWorldMap = true
                }
            }
            else if tabViewSteps == .egg {
                withAnimation(.linear(duration: 0.2)) {
                        self.isWorldMap = false
                }
            }
        }
    }
}

//struct LofiMainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            LofiMainTabView()
//        }
//    }
//}
