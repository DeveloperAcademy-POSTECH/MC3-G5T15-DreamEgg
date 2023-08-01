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
//    @State private var tabSelection: Int = 1
    @Binding var tabSelection: Int
    @State private var isWorldMap: Bool = false
    
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
