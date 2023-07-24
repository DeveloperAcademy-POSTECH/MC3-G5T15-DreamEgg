//
//  CoreDataRepresentable.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/24.
//

import CoreData

// MARK: Interface
protocol CoreDataRepresentable {
    var managedObjectContext: NSManagedObjectContext { get }
    
    func fetchCoreData<CoreDataObject: NSManagedObject>(
        _ coreDataObject: CoreDataObject.Type,
        predicate: NSPredicate,
        fetchLimit: Int
    ) -> Result<[CoreDataObject]?, Error>
    
    func saveChangesToContext() -> Void
    
    func updateCoreData<
        AppEntityModel: CoreDataIdentifiable,
        CoreDataObject: NSManagedObject
    >(
        with appEntityModel: AppEntityModel,
        completionHandler: @escaping (CoreDataObject, AppEntityModel) -> Void
    ) -> Void
}

extension CoreDataRepresentable {
    
    /// CoreData의 Entity에 실제 접근하여 값을 저장 및 업데이트합니다
    /// - Parameters:
    ///   - appEntityModel: App 내에서 활용하는 Model 타입을 전달합니다. 모델은 CoreDataIdentifiable을 채택해야 합니다.
    ///   - completionHandler: completionHandler로 어떤 값들을 새로 업데이트하여 저장할지 구현하여 전달합니다.
    ///```
    ///// completion Handler Example
    ///coreDataObject.id = appEntityModel.id
    ///coreDataObject.property1 = appEntityModel.targetSleepTime
    ///coreDataObject.property2 = appEntityModel.notificationMessage
    ///```
    /// - Important: completionHandler는 꼭 id를 할당해주는 로직이 필요합니다.
    public func updateCoreData<
        AppEntityModel: CoreDataIdentifiable,
        CoreDataObject: NSManagedObject
    >(
        with appEntityModel: AppEntityModel,
        completionHandler: @escaping (CoreDataObject, AppEntityModel) -> Void
    ) -> Void {
        let predicate = NSPredicate(
            format: "id = %@",
            appEntityModel.id as CVarArg
        )
        
        let result = fetchCoreData(
            CoreDataObject.self,
            predicate: predicate,
            fetchLimit: 1
        )
        
        switch result {
        case let .success(fetchedCoreDataObject):
            if let fetchedCoreDataObject = fetchedCoreDataObject?.first {
                completionHandler(fetchedCoreDataObject, appEntityModel)
            } else {
                let managedCoreDataObject = CoreDataObject(
                    context: managedObjectContext
                )
                completionHandler(managedCoreDataObject, appEntityModel)
            }
        case let .failure(error):
            print("\(appEntityModel.self) Type Fetched Failed: ", "\(error)")
        }
        
        saveChangesToContext()
    }
    
    /// CoreData의 NSManagedObject 타입을 Fetch하는 Protocol의 기본 구현 메소드 입니다.
    /// - Parameters:
    ///   - coreDataObject: CoreData Entity의 타입 자체를 아규먼트로 받습니다.
    ///   - predicate: CoreData 의 검색 규칙, 필터 규칙을 받습니다.
    ///   - fetchLimit: 기본값은 1이며, fetch가 호출될 때 몇 차례 호출할지 제한을 받습니다.
    /// - Returns: 결과 타입이며, fetch 성공시 CoreDataObject 요소를 담은 옵셔널 배열을 리턴합니다.
    func fetchCoreData<CoreDataObject: NSManagedObject>(
        _ coreDataObject: CoreDataObject.Type,
        predicate: NSPredicate,
        fetchLimit: Int
    ) -> Result<[CoreDataObject]?, Error> {
        let request = coreDataObject.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = fetchLimit
        
        do {
            let result = try managedObjectContext.fetch(request) as? [CoreDataObject]
            return .success(result)
        } catch {
            print("COREDATA: FETCH \(coreDataObject) TYPE DATA FAILED ", error)
            return .failure(error)
        }
    }

    func saveChangesToContext() -> Void {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}
