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
    
    private var userSleepConfigDict: Dictionary<UUID, UserSleepConfiguration> = [:]
    private let standardMinute = -(12 * 60)
    
    @Published public var targetSleepTime: Date = .now
    @Published public var notificationMessage: String = Constant.BASE_NOTIFICATION_MESSAGE
    
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
        
        assignInitProperties()
    }
    
    // MARK: Methods
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
    
    public func assignProperties(
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
        
        let targetSleepTimeToMinute = targetSleepTime.hour * 60 + targetSleepTime.minute
        let currentTimeToMinute = currentTime.hour * 60 + currentTime.minute
        
        let leftMinuteUntilSleep = targetSleepTimeToMinute - currentTimeToMinute
        let leftHour = (abs(leftMinuteUntilSleep) / 60) % 24
        let leftMinute = abs(leftMinuteUntilSleep % 60)
//        print("시간 뒤 잠에 듭니다: ", leftHour,":", leftMinute)
        
        return leftHour > 0
        ? "\(leftHour)시간 \(abs(leftMinute))분"
        : "\(leftMinute)분"
    }
    
    /// 유저가 실제로 수면 루틴을 진행할 수 있는지를 확인합니다.
    public func hasUserEnoughTimeToProcess(currentTime: Date) -> Bool {
        let targetSleepTimeToMinute = targetSleepTime.hour * 60 + targetSleepTime.minute
        let currentTimeToMinute = currentTime.hour * 60 + currentTime.minute
        
        let leftMinuteUntilSleep = targetSleepTimeToMinute - currentTimeToMinute
        
        if leftMinuteUntilSleep < 0 {
            // 남은 시간이 없다면 잘 수 없다.
            return false
        } else if leftMinuteUntilSleep >= standardMinute,
           leftMinuteUntilSleep <= abs(standardMinute) {
            // 12시간 범위 내에 있어야 잘 수 있다
            return true
        } else if leftMinuteUntilSleep > 0,
                  leftMinuteUntilSleep <= abs(standardMinute) {
            // 잠들기전까지 남은 시간이 0분보다 많고 12시간 범위 내에 있다면 잘 수 있다.
            return true
        } else {
            // 그외의 경우에는 못잠
            return false
        }
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
