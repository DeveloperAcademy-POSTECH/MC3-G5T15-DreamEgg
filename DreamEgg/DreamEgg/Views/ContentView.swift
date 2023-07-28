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
    @EnvironmentObject var localNotificationManager: LocalNotificationManager
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    
    @Environment(\.scenePhase) var scene
        
    var body: some View {
        switch navigationManager.viewCycle {
        case .splash:
            splashMock
                .onAppear {
                    localNotificationManager.requestNotificationPermission()
                }
                .onChange(of: localNotificationManager.hasNotificationStatusAuthorized) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            if isSleepingProcessing() {
                                print(#function, "쉿 자는중", dailySleepTimeStore.currentDailySleep)
                                navigationManager.viewCycle = .awake
                            } else if userSleepConfigStore.hasSleepConfig {
                                // 수면시간이 있는 유저
                                navigationManager.viewCycle = .general
                            } else {
                                // 아무 설정을 하지 않은 유저 == 스타터
                                navigationManager.viewCycle = .timeSetting
                            }
                        }
                    }
                }
            
        case .timeSetting:
            LofiSleepTimeSettingView()
                .frame(maxWidth: .infinity)
                .onAppear {
                    localNotificationManager.getNotificationstatus()
                }
                .onChange(of: self.scene) { newScene in
                    if isChangingFromInactiveScene(into: newScene) {
                        localNotificationManager.getNotificationstatus()
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(
                            edge:
                                isUserNotificationAuthorized()
                            ? .trailing
                            : .bottom
                        )
                        .animation(.easeInOut(duration: 1)),
                        removal: .move(
                            edge: .leading
                        )
                        .animation(.easeInOut(duration: 1))
                    )
                )
            
        case .notificationMessageSetting:
            LofiTextCustomView()
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .bottom)
                    )
                )
            
        case .general:
            NavigationStack {
                LofiMainTabView()
            }
            
        case .awake:
            NavigationStack {
                LofiAwakeView()
                    .transition(
                        .asymmetric(
                            insertion: .opacity,
                            removal: .opacity
                        )
                    )
            }
        }
    }
    
    // MARK: Methods
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
    
    private func isUserNotificationAuthorized() -> Bool {
        localNotificationManager.hasNotificationStatusAuthorized != nil
        && localNotificationManager.hasNotificationStatusAuthorized! == .authorized
    }
    
    private func isChangingFromInactiveScene(into newScene: ScenePhase) -> Bool {
        scene == .inactive && newScene == .active ||
        scene == .background && newScene == .active
    }
    
    private func isSleepingProcessing() -> Bool {
        if let processingSleep = dailySleepTimeStore.currentDailySleep,
           processingSleep.processStatus == Constant.SLEEP_PROCESS_PROCESSING
            || processingSleep.processStatus == Constant.SLEEP_PROCESS_SLEEPING {
            print(#function)
            return true
        } else {
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
