//
//  UserSleepConfigStore.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/22.
//

import SwiftUI

final class UserSleepConfigStore: ObservableObject {
    @Published private var coreDataStore: CoreDataStore = .debugShared
    
    @Published public var targetSleepTime: Date = .now
    @Published public var currentTime: Date = .now
    @Published public var notificationMessage: String = Constant.BASE_NOTIFICATION_MESSAGE
    
    @Published private var userSleepConfigDict: Dictionary<UUID, UserSleepConfiguration> = [:]
    
    public var existingUserSleepConfig: UserSleepConfiguration {
        if userSleepConfigDict.isEmpty {
            // MARK: Init for base config
            self.updateAndSaveUserSleepConfig(
                with: .init(
                    id: .init(),
                    targetSleepTime: targetSleepTime,
                    notificationMessage: notificationMessage
                )
            )
        }
        
        return Array(userSleepConfigDict.values)[0]
    }
    
    // MARK: LIFECYCLE
    init(coreDataStore: CoreDataStore = .debugShared) {
        self.coreDataStore = coreDataStore
        self.userSleepConfigDict = coreDataStore.userSleepConfig
    }
    
    // MARK: Methods
    /**
     coreDataStore에 model을 전달하여 update, save를 진행합니다.
     */
    public func updateAndSaveUserSleepConfig(
        with userSleepConfig: UserSleepConfigurationInfo
    ) {
        coreDataStore.updateUserSleepConfig(with: userSleepConfig)
        print(#function, coreDataStore.userSleepConfig)
        assignUserSleepConfigDict()
        assignProperties(with: userSleepConfig)
    }
    
    private func assignUserSleepConfigDict() {
        self.userSleepConfigDict = coreDataStore.userSleepConfig
    }
    
    public func assignProperties(
        with userSleepConfig: UserSleepConfigurationInfo
    ) {
        self.targetSleepTime = userSleepConfig.targetSleepTime
        self.notificationMessage = userSleepConfig.notificationMessage
    }
    
    // MARK: HELPERS
    public func formattedDateHourAndMinute() -> String {
        let leftHour = abs(targetSleepTime.hour - currentTime.hour)
        let leftMinute = abs(targetSleepTime.minute - currentTime.minute)
        
        return leftHour != 0
        ? "\(leftHour)시간 \(leftMinute)분"
        : "\(leftMinute)분"
    }
    
    /// 유저가 실제로 수면 루틴을 진행할 수 있는지를 확인합니다.
    /// - Returns: 목표 수면 시간이 현재 시간보다 이전일 때, true 목표 수면 시간이 현재 시간과 같거나 지나가면, false
    public func hasUserEnoughTimeToProcess() -> Bool {
        if targetSleepTime.hour < 12,
           currentTime.hour > 12 {
            return currentTime.hour > targetSleepTime.hour + 24
            && currentTime.minute > targetSleepTime.minute
        } else if targetSleepTime.hour < 12,
                  currentTime.hour < 12 {
            return currentTime.hour > targetSleepTime.hour + 24
            && currentTime.minute > targetSleepTime.minute
        } else {
            return currentTime.hour >= targetSleepTime.hour
            && currentTime.minute > targetSleepTime.minute
        }
    }
}
