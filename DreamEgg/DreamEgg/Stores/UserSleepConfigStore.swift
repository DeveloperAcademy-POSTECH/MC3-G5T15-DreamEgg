//
//  UserSleepConfigStore.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/22.
//

import SwiftUI

final class UserSleepConfigStore: ObservableObject {
    @Published private var coreDataStore: CoreDataStore = .debugShared
    @Published public var userSleepConfigDict: Dictionary<UUID, UserSleepConfiguration> = [:]
    
    public var userSleepConfig: UserSleepConfiguration {
        if userSleepConfigDict.isEmpty {
            // MARK: Init for base config
            self.updateAndSaveUserSleepConfig(
                with: .init(
                    id: .init(),
                    targetSleepTime: Constant.BASE_TARGET_SLEEP_TIME,
                    notificationMessage: Constant.BASE_NOTIFICATION_MESSAGE
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
    public func updateAndSaveUserSleepConfig(with model: UserSleepConfigurationInfo) {
        coreDataStore.updateAndSaveUserSleepConfig(with: model)
        assignUserSleepConfigDict()
    }
    
    private func assignUserSleepConfigDict() {
        self.userSleepConfigDict = coreDataStore.userSleepConfig
    }
}
