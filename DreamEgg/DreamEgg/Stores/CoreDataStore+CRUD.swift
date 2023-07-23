//
//  CoreDataStore+CRUD.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/23.
//

import CoreData

extension CoreDataStore {
    private func fetchFirst<T: NSManagedObject>(
        _ objectType: T.Type,
        predicate: NSPredicate?
    ) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
}

extension CoreDataStore {
    private func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    public func updateUserSleepConfig(
        with userSleepConfig: UserSleepConfigurationInfo
    ) {
        let predicate = NSPredicate(
            format: "id = %@",
            userSleepConfig.id as CVarArg
        )
        
        let result = fetchFirst(
            UserSleepConfiguration.self,
            predicate: predicate
        )
        
        switch result {
        case let .success(managedUserSleepConfig):
            // 기존 저장된 CoreData Entity가 있다면 속성 할당하고 곧바로 업데이트
            if let managedUserSleepConfig {
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
        
        saveData()
    }
    
    private func saveUserSleepConfig(from config: UserSleepConfigurationInfo) {
        let managedUserSleepConfig = UserSleepConfiguration(
            context: managedObjectContext
        )
        
        managedUserSleepConfig.id = config.id
        assignConfigProperties(
            managedUserSleepConfig: managedUserSleepConfig,
            from: config
        )
    }
    
    private func assignConfigProperties(
        managedUserSleepConfig: UserSleepConfiguration,
        from configInfo: UserSleepConfigurationInfo
    ) {
        managedUserSleepConfig.targetSleepTime = configInfo.targetSleepTime
        managedUserSleepConfig.notificationMessage = configInfo.notificationMessage
    }
}
