//
//  ContentView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var navigationManager: DENavigationManager
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    
    var body: some View {
        switch navigationManager.viewCycle {
        case .splash:
            splashMock
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            if userSleepConfigStore.targetSleepTime == Constant.BASE_TARGET_SLEEP_TIME {
                                // 수면시간을 설정한 유저 == general
                                navigationManager.viewCycle = .general
                            } else {
                                // 아직 아무 설정을 하지 않은 유저 == 스타터
                                navigationManager.viewCycle = .starter
                            }
                        }
                    }
                }
            
        case .starter:
            NavigationStack(path: $navigationManager.starterPath) {
                LofiSleepTimeSettingView()
                    .frame(maxWidth: .infinity)
            }
            
        case .timeSetting:
            LofiSleepTimeSettingView()
            
        case .general:
            NavigationStack {
                LofiMainTabView()
            }
        }
    }
    
    private var splashMock: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Spacer()
                
                Image("DreamEggIcon")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                
                Text("Dream Egg")
                    .font(.dosPilgi(.title))
                    .foregroundColor(.primary)
                    .colorInvert()
                
                Spacer()
                
                Text("Copyright 2023 K-Jammy All rights reserved.")
                    .font(.dosIyagiBold(.caption))
                    .foregroundColor(.primary)
                    .colorInvert()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
