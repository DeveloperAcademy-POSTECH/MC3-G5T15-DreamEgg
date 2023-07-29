//
//  CoreDataRepresentable.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/24.
//

import CoreData

// MARK: Interface
protocol CoreDataManagable {
    var managedObjectContext: NSManagedObjectContext { get }
}

protocol CoreDataRepresentable {
    associatedtype CoreDataObject: NSManagedObject
    associatedtype AppEntityModel: CoreDataIdentifiable
    
    var coreDataStore: CoreDataStore { get }
    
    func fetchCoreData<CoreDataObject: NSManagedObject>(
        _ coreDataObject: CoreDataObject.Type,
        predicate: NSPredicate,
        fetchLimit: Int
    ) -> Result<[CoreDataObject]?, Error>
    
    func saveChangesToContext() -> Void
    
    /// CoreData의 Entity에 실제 접근하여 값을 저장 및 업데이트합니다
    /// - Parameters:
    ///   - appEntityModel: App 내에서 활용하는 Model 타입을 전달합니다.
    ///   - predicate: CoreData 내의 데이터 색인 조건을 NSPredicate 타입으로 만들어 전달합니다.
    ///   앱 모델은 CoreDataIdentifiable을 채택해야 합니다.
    func updateCoreData(
        with appEntityModel: AppEntityModel,
        predicate: NSPredicate
    ) -> Void
    
    func assignProperties(
        to coreData: CoreDataObject,
        from appEntityModel: AppEntityModel
    )
}

extension CoreDataRepresentable {
    
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
            let result = try coreDataStore.managedObjectContext.fetch(request) as? [CoreDataObject]
            return .success(result)
        } catch {
            print("COREDATA: FETCH \(coreDataObject) TYPE DATA FAILED ", error)
            return .failure(error)
        }
    }
    
    func removeCoreData(
        with: CoreDataObject,
        predicate: NSPredicate
    ) -> Void {
        let result = fetchCoreData(
            CoreDataObject.self,
            predicate: predicate,
            fetchLimit: 1
        )
        
        switch result {
        case let .success(fetchedCoreDataObject):
            if let fetchedCoreDataObject = fetchedCoreDataObject?.first {
                coreDataStore.managedObjectContext.delete(fetchedCoreDataObject)
            }
        case let .failure(err):
            print("\(coreDataStore.self) Type Delete Failed: ", "\(err)")
        }
        
        saveChangesToContext()
    }
    
    func getNSPredicate(
        format: String = "id = %@",
        with appEntityModel: AppEntityModel
    ) -> NSPredicate {
        NSPredicate(
            format: "id = %@",
            appEntityModel.id as CVarArg
        )
    }
    
    public func updateCoreData(
        with appEntityModel: AppEntityModel,
        predicate: NSPredicate
    ) -> Void {
        let result = fetchCoreData(
            CoreDataObject.self,
            predicate: predicate,
            fetchLimit: 1
        )
        
        switch result {
        case let .success(fetchedCoreDataObject):
            if let fetchedCoreDataObject = fetchedCoreDataObject?.first {
                print("HAS FETCHED FROM COREDATA!: ", fetchedCoreDataObject.description)
                assignProperties(to: fetchedCoreDataObject, from: appEntityModel)
            } else {
                let managedCoreDataObject = CoreDataObject(
                    context: coreDataStore.managedObjectContext
                )
                print("HAS FETCHED FROM COREDATA!: ", managedCoreDataObject.description)
                assignProperties(to: managedCoreDataObject, from: appEntityModel)
            }
        case let .failure(error):
            print("\(appEntityModel.self) Type Fetched Failed: ", "\(error)")
        }

        saveChangesToContext()
    }


    func saveChangesToContext() -> Void {
        if coreDataStore.managedObjectContext.hasChanges {
            print(#function, coreDataStore.managedObjectContext)
            do {
                try coreDataStore.managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}
