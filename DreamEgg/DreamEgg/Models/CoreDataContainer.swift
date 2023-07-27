//
//  UserSleepTime.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import CoreData
import UIKit

/**
 CoreData App을 이어주는 역할을 수행하는 Container 입니다.
 App 내에서 발생하는 데이터를 저장할 container의 context를 지정하고, CoreData Container를 "DreamEgg"로 초기화 합니다.
 각 CoreData의 객체가 View에서 변동되었을 경우, saveContext가 트리거 되며, 자동으로 CoreData가 업데이트 됩니다.
 NSManageedObjectContext는 CoreDataStore 객체에서 추가로 관리합니다.
 */
struct CoreDataContainer {
    enum ContainerMemoryType {
        case debug, release
    }
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    // MARK: LIFECYCLE
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DreamEgg")
        
        if inMemory {
            // MARK: For Debug
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Load
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print(#function, "LOAD CORE DATA CONTAINER FAILED: \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: Methods
    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let err {
                print(#function, #line, "\(err): CONTEXT SAVE FAILED.")
            }
        }
    }
    
    /**
     Container의 성질에 따라 하나의 shared Instance를 리턴합니다.
     */
    static public func getSharedInstance(with type: ContainerMemoryType) -> Self {
        switch type {
        case .debug:
            return CoreDataContainer(inMemory: true)
        case .release:
            return CoreDataContainer(inMemory: false)
        }
    }
}

struct DailySleepInfo: CoreDataIdentifiable {
    enum SleepProcessStatus {
        case ready
        case processing
        case sleeping
        case stopped
        case complete
        
        public var description: String {
            switch self {
            case .ready:
                return Constant.SLEEP_PROCESS_READY
            case .processing:
                return Constant.SLEEP_PROCESS_PROCESSING
            case .sleeping:
                return Constant.SLEEP_PROCESS_SLEEPING
            case .complete:
                return Constant.SLEEP_PROCESS_STOPPED
            case .stopped:
                return Constant.SLEEP_PROCESS_COMPLETE
            }
        }
    }
    
    var id: UUID
    var animalName: String
    var date: Date
    var sleepTimeInMinute: Int32
    var eggName: String
    var processStatus: SleepProcessStatus
    var assetName: String
    
    private init() {
        self.id = UUID()
        self.animalName = ""
//        Constant.DreamPets.DREAMPET_NAME_SET.randomElement()!
        self.eggName = ""
//        Constant.DreamPets.DREAMPET_EGGNAME_SET.randomElement()!
        self.date = .now
        self.sleepTimeInMinute = Int32()
        self.processStatus = .ready
        self.assetName = ""
    }
    
    init(
        id: UUID,
        animalName: String,
        eggName: String,
        date: Date,
        sleepTimeInMinute: Int32,
        processStatus: SleepProcessStatus,
        assetName: String
    ) {
        self.id = id
        self.animalName = animalName
        self.eggName = eggName
        self.date = date
        self.sleepTimeInMinute = sleepTimeInMinute
        self.processStatus = processStatus
        self.assetName = assetName
    }
    
    static func getBlankDailySleepInfo() -> Self {
        DailySleepInfo()
    }
}

struct UserSleepConfigurationInfo: CoreDataIdentifiable {
    var id: UUID
    var targetSleepTime: Date
    var notificationMessage: String
}

protocol CoreDataIdentifiable: Identifiable {
    var id: UUID { get set }
}
