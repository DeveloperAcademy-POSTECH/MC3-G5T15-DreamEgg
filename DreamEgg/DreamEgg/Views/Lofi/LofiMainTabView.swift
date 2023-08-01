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
    @State private var isSettingMenuDisplayed: Bool = false
    @Binding var tabSelection: Int
    @State private var isWorldMap: Bool = false
    
    var body: some View {
        ZStack {
            if tabSelection == 2 {
                Image("DreamWorldMap")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            } else {
                GradientBackgroundView()
                    .onTapGesture {
                        withAnimation {
                            if isSettingMenuDisplayed {
                                isSettingMenuDisplayed = false
                            }
                        }
                    }
            }
            
            TabView(selection: $tabSelection) {
                DECalendarTestView()
                    .tag(0)
                    .tabItem {
                        Image("CalendarTabIcon")
                    }
                
                // MARK: Main Egg
                LofiMainEggView(isSettingMenuDisplayed: $isSettingMenuDisplayed)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .tag(1)
                    .tabItem {
                        Image("DreamEggTabIcon")
                    }
                
                LofiDreamWorldView()
                    .onAppear {
                        withAnimation(.linear(duration: 0.4)) {
                            self.isWorldMap = true
                        }
                    }
                    .onDisappear {
                        withAnimation(.linear(duration: 0.4)) {
                            self.isWorldMap = true
                        }
                    }
                    .tag(2)
                    .tabItem {
                        Image("DreamWorldTabIcon")
                    }
            }
            .tabViewStyle(.page)
        }
        .navigationBarBackButtonHidden()
        .background(Color.black)
    }
}

//struct LofiMainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            LofiMainTabView()
//        }
//    }
//}
