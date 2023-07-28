//
//  UserSleepConfigStore.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/22.
//

import SwiftUI

final class UserSleepConfigStore: ObservableObject {
//    internal var coreDataStore: CoreDataStore = .debugShared
    internal var coreDataStore: CoreDataStore = .releaseShared
    
    public var userSleepConfigDict: Dictionary<UUID, UserSleepConfiguration> = [:]
    private let standardMinute = -(12 * 60)
    
    @Published public var targetSleepTime: Date = .now
    @Published public var notificationMessage: String = Constant.BASE_NOTIFICATION_MESSAGE 
    @Published public var hasSleepConfig: Bool = false
    
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
        
        return Array(userSleepConfigDict.values).first
        ?? .init(context: coreDataStore.managedObjectContext)
    }
    
    // MARK: LIFECYCLE
    init(coreDataStore: CoreDataStore = .releaseShared) {
        self.coreDataStore = coreDataStore
        self.userSleepConfigDict = coreDataStore.userSleepConfig
        
        checkIfUserIsStarter()
        assignInitProperties()
    }
    
    // MARK: Methods
    private func checkIfUserIsStarter() {
        if coreDataStore.userSleepConfig.isEmpty {
            self.hasSleepConfig = false
        } else {
            self.hasSleepConfig = true
        }
    }
    
    private func assignInitProperties() {
        self.targetSleepTime = existingUserSleepConfig.targetSleepTime!
        self.notificationMessage = existingUserSleepConfig.notificationMessage!
    }
    
    /**
     coreDataStore에 model을 전달하여 update, save를 진행합니다.
     */
    public func updateAndSaveUserSleepConfig(
        with userSleepConfig: UserSleepConfigurationInfo
    ) {
        updateCoreData(
            with: userSleepConfig,
            predicate: getNSPredicate(with: userSleepConfig)
        )
//        print(#function, coreDataStore.userSleepConfig)
        assignUserSleepConfigDict()
        assignProperties(with: userSleepConfig)
    }
    
    private func assignUserSleepConfigDict() {
        self.userSleepConfigDict = coreDataStore.userSleepConfig
    }
    
    private func assignProperties(
        with userSleepConfig: UserSleepConfigurationInfo
    ) {
        self.targetSleepTime = userSleepConfig.targetSleepTime
        self.notificationMessage = userSleepConfig.notificationMessage
    }
    
    // MARK: HELPERS
    public func hourAndMinuteString(currentTime: Date) -> String {
        /// a. 어제했다 : "오늘도 목표 시간에 잘 자볼까요?"
        /// b. 어제안했다 : "다람쥐 헛둘헛둘"
        
        // + 목표시간: 00시 15분 | 00시 15분 | 00시 15분 | 00시 15분 | 00시 15분  | 00시 15분
        // - 현재시간: 23시 30분 | 00시 00분 | 00시 34분 | 05시 30분 | 11시 00분  | 12시 15분
        // ------------------------------------------------------------------------
        // = 남은시간: 00시 45분 | 00시 15분 | 00시 -19분| -5시 15분 | -11시 15분 | -12시 00분
        // = 가능여부: 성공      | 성공      | 실패      | 실패      | 실패       | 성공
        
        // + 목표시간: 23시 59분 | 23시 59분 | 23시 59분 | 23시 59분 | 23시 59분 | 23시 59분
        // - 현재시간: 23시 30분 | 24시 00분 | 24시 34분 | 05시 59분 | 11시 59분 | 13시 59분
        // ------------------------------------------------------------------------
        // = 남은시간: 00시 29분 | 00시 -1분 | 00시 -35분| -6시 00분 | 12시 00분 | 10시 00분
        // = 가능여부: 성공      | 실패      | 실패      | 실패      | 성공      | 성공
        
        var targetSleepTimeToMinute = targetSleepTime.hour * 60 + targetSleepTime.minute
        var currentTimeToMinute = currentTime.hour * 60 + currentTime.minute
        
        // 목표 수면시간은 00시~12시이고 현재 시간은 12시~00시일 경우
        if targetSleepTimeToMinute <= 720,
           currentTimeToMinute > 720, currentTimeToMinute < 1440 {
            // 목표 수면 시간이 하루 더 많다고 가정
            targetSleepTimeToMinute += 24 * 60
        } else if currentTimeToMinute <= 720,
                  targetSleepTimeToMinute > 720, targetSleepTimeToMinute < 1440 {
            // 목표 수면시간은 12시~00시이고 현재 시간은 00시~12시일 경우
            // 현재 시간이 하루 더 길다고 가정
            currentTimeToMinute += 24 * 60
        }
        
        let leftMinuteUntilSleep = targetSleepTimeToMinute - currentTimeToMinute
        
        return "\(leftMinuteUntilSleep)분"
    }
    
    /// 유저가 실제로 수면 루틴을 진행할 수 있는지를 확인합니다.
    public func hasUserEnoughTimeToProcess(currentTime: Date) -> Bool {
        var targetSleepTimeToMinute = targetSleepTime.hour * 60 + targetSleepTime.minute
        var currentTimeToMinute = currentTime.hour * 60 + currentTime.minute
        
        // 목표 수면시간은 00시~12시이고 현재 시간은 12시~00시일 경우
        if targetSleepTimeToMinute <= 720,
           currentTimeToMinute > 720, currentTimeToMinute < 1440 {
            // 목표 수면 시간이 하루 더 많다고 가정
            targetSleepTimeToMinute += 24 * 60
        } else if currentTimeToMinute <= 720,
                  targetSleepTimeToMinute > 720, targetSleepTimeToMinute < 1440 {
            // 목표 수면시간은 12시~00시이고 현재 시간은 00시~12시일 경우
            // 현재 시간이 하루 더 길다고 가정
            currentTimeToMinute += 24 * 60
        }
        
        let leftMinuteUntilSleep = targetSleepTimeToMinute - currentTimeToMinute
        
//        print(
//            "지금 시간: ", currentTime.formatted(), "\n",
//            "타겟 시간: ", targetSleepTime.formatted(), "\n",
//
//            "최후의 승자는?", leftMinuteUntilSleep, "\n",
//            "타겟 미닛: ", targetSleepTimeToMinute, "\n",
//            "지금 미닛: ", currentTimeToMinute, "\n"
//        )
        
        if leftMinuteUntilSleep < 0 {
            // 남은 시간이 없다면 잘 수 없다.
            return false
        } else if leftMinuteUntilSleep >= 0,
                  leftMinuteUntilSleep <= 60 {
            // 1시간만 보여준다요
            return true
        } else {
            return false
        }
    }
    
    private func getAccurateMinute(with date: Date) -> Int {
        
        return date.hour != 0
        ? date.hour * 60 + date.minute
        : 24 * 60 + date.minute
    }
}

extension UserSleepConfigStore: CoreDataRepresentable {
    func assignProperties(
        to coreData: UserSleepConfiguration,
        from appEntityModel: UserSleepConfigurationInfo
    ) {
        coreData.id = appEntityModel.id
        coreData.targetSleepTime = appEntityModel.targetSleepTime
        coreData.notificationMessage = appEntityModel.notificationMessage
    }
}
