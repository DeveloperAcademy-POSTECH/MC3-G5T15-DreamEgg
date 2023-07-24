//
//  CoreDataStore+CRUD.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/23.
//

import CoreData

extension CoreDataStore: CoreDataRepresentable {
    public func updateUserSleepConfig(
        with userSleepConfig: UserSleepConfigurationInfo
    ) {
        let predicate = NSPredicate(
            format: "id = %@",
            userSleepConfig.id as CVarArg
        )
        
        let result = fetchCoreData(
            UserSleepConfiguration.self,
            predicate: predicate,
            fetchLimit: 1
        )
        
        switch result {
        case let .success(managedUserSleepConfig):
            // 기존 저장된 CoreData Entity가 있다면 속성 할당하고 곧바로 업데이트
            if let managedUserSleepConfig = managedUserSleepConfig?.first {
                assignConfigProperties(
                    managedUserSleepConfig: managedUserSleepConfig,
                    from: userSleepConfig
                )
            } else {
                // 기존 저장된 CoreData Entity가 없다면 새로 만들어서 속성 할당하고 업데이트
                saveUserSleepConfig(from: userSleepConfig)
            }
        case .failure(_):
            print("Couldn't fetch TodoMO to save")
        }
        
        saveChangesToContext()
    }
    
    private func saveUserSleepConfig(from config: UserSleepConfigurationInfo) {
        let managedUserSleepConfig = UserSleepConfiguration(
            context: managedObjectContext
        )
        
        assignConfigProperties(
            managedUserSleepConfig: managedUserSleepConfig,
            from: config
        )
    }
    
    private func assignConfigProperties(
        managedUserSleepConfig: UserSleepConfiguration,
        from configInfo: UserSleepConfigurationInfo
    ) {
        managedUserSleepConfig.id = configInfo.id
        managedUserSleepConfig.targetSleepTime = configInfo.targetSleepTime
        managedUserSleepConfig.notificationMessage = configInfo.notificationMessage
    }
}
