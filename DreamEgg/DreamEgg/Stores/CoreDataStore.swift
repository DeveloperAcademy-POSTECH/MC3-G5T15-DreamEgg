//
//  CoreDataStore.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import CoreData
import Foundation
import SwiftUI

/**
 CoreData에서 가져온 각종 데이터를 보관합니다.
 - Important: 해당 구조체는 단 하나의 인스턴스만을 갖도록 합니다.
 */
final class CoreDataStore: NSObject, ObservableObject {
    static public let debugShared = CoreDataStore(storeType: .debug)
    static public let releaseShared = CoreDataStore(storeType: .release)
    
    private(set) var managedObjectContext: NSManagedObjectContext
    
    private let dailySleepController: NSFetchedResultsController<DailySleep>
    private let userSleepConfigController: NSFetchedResultsController<UserSleepConfiguration>
    
    @Published
    public var dailySleep: Dictionary<UUID, DailySleep> = [:]
    
    @Published
    public var userSleepConfig: Dictionary<UUID, UserSleepConfiguration> = [:]
    
    
    // MARK: LIFECYCLE
    /**
     Debug, Release 용 Store를 구별하여 초기화할 수 있도록 구현된 생성자 입니다.
     */
    private init(storeType: CoreDataContainer.ContainerMemoryType) {
        let coreDataContainer = CoreDataContainer.getSharedInstance(with: storeType)
        self.managedObjectContext = coreDataContainer.context
        
        // MARK: Daily Sleep Infos
        let dailySleepFetchRequest: NSFetchRequest<DailySleep> = DailySleep.fetchRequest()
        dailySleepFetchRequest.sortDescriptors = [
            .init(
                key: "date",
                ascending: true
            )
        ]
        
        self.dailySleepController = NSFetchedResultsController(
            fetchRequest: dailySleepFetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        // MARK: User's Sleep Time Config
        let userSleepConfigFetchReqeust: NSFetchRequest<UserSleepConfiguration> = UserSleepConfiguration.fetchRequest()
        userSleepConfigFetchReqeust.sortDescriptors = [
            .init(
                key: "id",
                ascending: true
            )
        ]
        
        self.userSleepConfigController = NSFetchedResultsController(
            fetchRequest: userSleepConfigFetchReqeust,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        dailySleepController.delegate = self
        userSleepConfigController.delegate = self
        
        // GET USERINFOS FROM CORE DATA
        getDailySleepData(dailySleepController)
        getUserSleepConfig(userSleepConfigController)
    }
    
    // MARK: Methods
    
    /**
     App이 처음 시동될 때, CoreData에 저장된 DailySleep 데이터를 모두 가져옵니다.
     fetch한 데이터는 dailySleep Dictionary에 저장됩니다.
     init시점의 데이터는 하위의 SleepTimeStore에 주입되며 App의 Lifecycle 동안 하위의 Store가 관리합니다.
     */
    private func getDailySleepData(_ dailySleepController: NSFetchedResultsController<DailySleep>) {
        try? dailySleepController.performFetch()
        if let newDailySleep = dailySleepController.fetchedObjects {
            print(">>>>>> FETCHED DailySleep FROM COREDATA <<<<<<")
            self.dailySleep = Dictionary(
                uniqueKeysWithValues: newDailySleep.map { ($0.id!, $0) }
            )
        } else {
            print("NO DailySleep in CORE DATA")
        }
    }
    
    private func getUserSleepConfig(
        _ userSleepConfig: NSFetchedResultsController<UserSleepConfiguration>
    ) {
        try? userSleepConfigController.performFetch()
        if let newUserSleepConfig = userSleepConfig.fetchedObjects {
            print(">>>>>> FETCHED UserSleepConfig FROM COREDATA <<<<<<")
            self.userSleepConfig = Dictionary(
                uniqueKeysWithValues: newUserSleepConfig.map { ($0.id!, $0) }
            )
        } else {
            print("NO UserSleepConfig >> Navigate To Starter")
        }
        
    }
    
    public func updateAndSaveDailySleep(
        with model: DailySleepInfo
    ) {
        do {
            let dailySleep = DailySleep(context: managedObjectContext)
            dailySleep.sleepTime = model.sleepTime
            dailySleep.date = model.date
            dailySleep.animalName = model.animalName
            dailySleep.id = .init()
            try managedObjectContext.save()
        } catch let error as NSError {
            print(#function, #line, "\(error): CONTEXT SAVE FAILED.")
        }
    }
    
    // MARK: User Sleep Config
    public func updateAndSaveUserSleepConfig(
        with model: UserSleepConfigurationInfo
    ) {
        do {
            let sleepConfig = UserSleepConfiguration(context: managedObjectContext)
            sleepConfig.id = .init()
            sleepConfig.notificationMessage = model.notificationMessage
            sleepConfig.targetSleepTime = model.targetSleepTime
            try managedObjectContext.save()
        } catch let error as NSError {
            print(#function, #line, "\(error): CONTEXT SAVE FAILED")
        }
    }
}

extension CoreDataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newDailySleeps = controller.fetchedObjects as? [DailySleep] {
            self.dailySleep = Dictionary(
                uniqueKeysWithValues: newDailySleeps.map { ($0.id!, $0) }
            )
        } else if let newUserSleepConfig = controller.fetchedObjects as? [UserSleepConfiguration] {
            self.userSleepConfig = Dictionary(
                uniqueKeysWithValues: newUserSleepConfig.map { ($0.id!, $0) }
            )
        }
    }
}
