//
//  DailySleepTimeStore.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/11.
//

import SwiftUI
import CoreData

final class DailySleepTimeStore: ObservableObject, CoreDataRepresentable {
//    internal var coreDataStore: CoreDataStore = .debugShared
    internal var coreDataStore: CoreDataStore = .releaseShared
    
    private var dailySleepDict: Dictionary<UUID, DailySleep> = [:]
    private let calendar: Calendar = Calendar.getCurrentCalendar()
    
    @Published public var dailySleepArray: [DailySleep] = []
    @Published public var currentDailySleep: DailySleep? {
        didSet {
            if let currentDailySleep {
                print("Store Updated!", currentDailySleep)
            }
        }
    }
    @Published public var selectedDailySleep: DailySleep?
    
    @Published public var sleepDates: [Date] = []
    @Published public var sleptHour: Int = 0
    @Published public var sleptMinute: Int = 0
    @Published public var sleepingTimeInMinute: Int = 0
        
    // MARK: - LIFECYCLE
    init(coreDataStore: CoreDataStore = .releaseShared) {
        self.coreDataStore = coreDataStore
        self.dailySleepDict = coreDataStore.dailySleep
        
        self.dailySleepArray = Array(dailySleepDict.values)
        self.sleepDates = self.dailySleepArray.compactMap { $0.date }
        assignDailySleepProcessing()
    }
    
    // MARK: -  Methods
    /// 알을 만든 시점 ~ 잠자기를 누르기 전 시점에 앱을 껐을 경우, processing 상태의 DailySleepInfo를 갖는다.
    /// - Returns: Processing Sleep
    private func getProcessingDailySleepInfo() -> DailySleepInfo {
        if let currentDailySleep,
           currentDailySleep.processStatus == Constant.SLEEP_PROCESS_PROCESSING.description
        {
            print(#function, currentDailySleep.processStatus!)
            return DailySleepInfo(
                id: currentDailySleep.id!,
                animalName: currentDailySleep.animalName!,
                eggName: currentDailySleep.eggName!,
                date: currentDailySleep.date!,
                sleepTimeInMinute: Int32(sleepingTimeInMinute),
                processStatus: .processing,
                assetName: currentDailySleep.animalName!
            )
        } else {
            return DailySleepInfo.getBlankDailySleepInfo()
        }
    }
    
    /// 잠자기를 누른 후, sleeping 상태의 DailySleepInfo를 갖는다.
    /// - Returns: Processing Sleep
    private func getSleepingDailySleepInfo() -> DailySleepInfo {
        if let currentDailySleep,
           currentDailySleep.processStatus == Constant.SLEEP_PROCESS_SLEEPING.description
        {
            print(#function, currentDailySleep.processStatus!)
            return DailySleepInfo(
                id: currentDailySleep.id!,
                animalName: currentDailySleep.animalName!,
                eggName: currentDailySleep.eggName!,
                date: currentDailySleep.date!,
                sleepTimeInMinute: Int32(sleepingTimeInMinute),
                processStatus: .sleeping,
                assetName: currentDailySleep.animalName!
            )
        } else {
            return DailySleepInfo.getBlankDailySleepInfo()
        }
    }
    
    public func getSleepTimeInMinute() {
//        print(#function, currentDailySleep!.processStatus!)

        if let sleptTime = self.currentDailySleep?.date {
            let sleptSecond = Int(sleptTime.distance(to: Date.now))
            self.sleepingTimeInMinute = sleptSecond / 60
            
            self.sleptHour = self.sleepingTimeInMinute / 60
            self.sleptMinute = self.sleepingTimeInMinute % 60
            print(#function, sleepingTimeInMinute)
        }
    }
    
    public func getAssetNameSafely() -> String {
        if let currentDailySleep,
           let assetName = currentDailySleep.assetName {
            return assetName
        } else {
            return Constant.Errors.NO_DREAMPET
        }
    }
    
    public func hasWellSleptDailySleep(
        in date: Date
    ) -> Bool {
        for dailySleepInfo in dailySleepArray {
            return Date.isSameDate(lhs: dailySleepInfo.date!, rhs: date) &&
            dailySleepInfo.sleepTimeInMinute >= 3 * 60
        }
        
        return false
    }
    
    private func getRandomDreampetName() -> String {
        let usedAnimalName = Set(
            dailySleepArray.filter {
                // CoreData에 저장된 이름 중, 3시간을 넘긴 녀석들은 다시 쓸 수가 없단다..
                $0.sleepTimeInMinute >= 3 * 60
            }
                .map {
                    $0.animalName!
                }
        )
        
        let availableNames = Constant.DreamPets.DREAMPET_NAME_SET.subtracting(
            usedAnimalName
        )
        
        return Array(availableNames).randomElement() ?? "없다고!"
    }
    
    private func getRandomEggName() -> String {
        let usedEggName = Set(
            dailySleepArray.filter {
                $0.sleepTimeInMinute >= 3 * 60
            }
                .map {
                    $0.eggName!
                }
        )
        
        let availableEggs = Constant.DreamPets.DREAMPET_EGGNAME_SET.subtracting(
            usedEggName
        )
        
        return Array(availableEggs).randomElement() ?? "없다!"
    }
}

// MARK: All Assigns
extension DailySleepTimeStore {
    /// 날짜를 바꿀 때마다, 해당 날짜에 해당하는 dailySleep을 찾고 store 내에 할당합니다.
    /// - Parameter selectedDate: 찾고자하는 날짜를 전달합니다.
    public func assignDailySleep(at selectedDate: Date) {
        for dailySleepInfo in dailySleepArray {
            if Date.isSameDate(lhs: dailySleepInfo.date!, rhs: selectedDate) {
                self.selectedDailySleep = dailySleepInfo
                break
            }
        }
    }
    
    /// 잠자기를 누른 후의 DailySleep을 찾고 self.currentDailySleep에 할당합니다.
    /// 이후, currentDailySleep을 바탕으로 앱 분기처리를 진행합니다.
    /// 이 메소드는 앱이 꺼지고 suspend 되었다가 active될 때 속성을 할당합니다.
    private func assignDailySleepProcessing() {
        print(#function, "FIND SLEEPING")
        let processing = self.dailySleepArray.filter {
            $0.processStatus == DailySleepInfo.SleepProcessStatus.sleeping.description
        }
        
        if let currentDailySleep = processing.first {
            print(#function, currentDailySleep.processStatus!)
            self.currentDailySleep = currentDailySleep
        }
    }
    
    private func assignDailySleepInfoArray() {
        self.dailySleepArray = Array(coreDataStore.dailySleep.values)
            .sorted(by: { lhs, rhs in
                lhs.date! > rhs.date!
            })
        
        self.currentDailySleep = self.dailySleepArray.first
//        print(#function, "After ASSIGN CURRENT Array and First", currentDailySleep)
        print(#function, currentDailySleep!.processStatus!)
    }
    
    internal func assignProperties(
        to coreData: DailySleep,
        from appEntityModel: DailySleepInfo
    ) {
        coreData.id = appEntityModel.id
        coreData.animalName = appEntityModel.animalName
        coreData.eggName = appEntityModel.eggName
        coreData.date = appEntityModel.date
        coreData.sleepTimeInMinute = appEntityModel.sleepTimeInMinute
        coreData.processStatus = appEntityModel.processStatus.description
        coreData.assetName = appEntityModel.assetName
    }
}

// MARK: COREDATA CRUD
extension DailySleepTimeStore {
    /// 기존의 currentDailySleep 데이터를 모두 DailySleepInfo 인스턴스에 덮어씁니다.
    /// inout 처리로 리턴 없이 nil 분기를 처리합니다.
    /// - Parameter model: currentDailySleep의 데이터를 덮어 쓸 DailySleepInfo 인스턴스
    private func assignCurrentDailySleep(to model: inout DailySleepInfo) {
        if let currentDailySleep {
            model.id = currentDailySleep.id!
            model.eggName = currentDailySleep.eggName!
            model.sleepTimeInMinute = currentDailySleep.sleepTimeInMinute
            model.animalName = currentDailySleep.animalName!
            model.assetName = currentDailySleep.assetName!
            model.date = currentDailySleep.date!
            print(#function, currentDailySleep.processStatus!)
        } else {
            print(#function, "current가 없다?")
        }
    }
    
    /**
     coreDataStore에 model을 전달하여 update, save를 진행합니다.
     잠을 자는 플로우가 시작되는 시점에 트리거되며
     processStatus를 processing으로 수정 할당합니다.
     만약 process 중에 앱이 꺼졌다면, processing 데이터를 찾아서 그대로 진행합니다.
     */
    public func updateAndSaveNewDailySleepInfo() {
        print(#function, "IN PROCESS", currentDailySleep)
        let inProcessingArray = dailySleepArray.filter {
            $0.processStatus == Constant.SLEEP_PROCESS_PROCESSING
        }
        
        if inProcessingArray.count > 0 {
            self.currentDailySleep = inProcessingArray.first
            print(#function, "IN PROCESS", currentDailySleep)
            
        } else {
            var model = makeNewDailySleepInfo()
            model.processStatus = .processing
            
            updateCoreData(
                with: model,
                predicate: getNSPredicate(with: model)
            )
            
            assignDailySleepInfoArray()
        }
    }
    
    @available(*, unavailable, message: "NOW FIX")
    public func updateDreamPetName(to name: String) {
        var model = self.getProcessingDailySleepInfo()
        assignCurrentDailySleep(to: &model)
        model.animalName = name
        
        updateCoreData(
            with: model,
            predicate: getNSPredicate(with: model)
        )
        assignDailySleepInfoArray()
    }
    
    /// 자러갈 때의 시작 시간을 현재로 변경해주고 sleeping 상태로 수정합니다.
    public func updateDailySleepTimeToNow() {
        var model = self.getProcessingDailySleepInfo()
        assignCurrentDailySleep(to: &model)
        
        if model.processStatus == .processing {
            model.processStatus = .sleeping
            // 실제로 화면이 어두어지는 시점부터 카운트한다.
            model.date = .now
        }
        
        print(#function, "After update", currentDailySleep)
        
        updateCoreData(with: model, predicate: getNSPredicate(with: model))
        assignDailySleepInfoArray()
    }
    
    /// dailySleepInfo를 complete하고 시간을 할당합니다.
    /// @Published 되어 있는 self.currentDailySleepInfo를 참조합니다.
    public func completeDailySleepTime() {
        print(#function, "COMPLETE THIS: ", currentDailySleep)
        var model = self.getSleepingDailySleepInfo()
        assignCurrentDailySleep(to: &model)
        model.processStatus = .complete
        model.sleepTimeInMinute = Int32(sleepingTimeInMinute)
        
        print(#function, "To THIS: ", currentDailySleep)
        
        updateCoreData(
            with: model,
            predicate: getNSPredicate(with: model)
        )
        
        assignDailySleepInfoArray()
    }
    
    /// 현재 진행중이던 수면 플로우를 멈춘다.
    /// 기존 coredata를 지우지 않고, 캘린더에서 잔 시간을 추적
    public func updateDailyInfoProcessToStop() {
        var dailySleepInfo: DailySleepInfo = .getBlankDailySleepInfo()
        let sleptTime = sleepingTimeInMinute < 0 ? -1 : sleepingTimeInMinute
        
        assignCurrentDailySleep(to: &dailySleepInfo)
        dailySleepInfo.assetName = Constant.Errors.NO_DREAMPET
        dailySleepInfo.animalName = Constant.Errors.NO_DREAMPET
        dailySleepInfo.eggName = Constant.Errors.NO_EGG
        dailySleepInfo.sleepTimeInMinute = Int32(sleptTime)
        dailySleepInfo.processStatus = .stopped
        
        updateCoreData(
            with: dailySleepInfo,
            predicate: getNSPredicate(with: dailySleepInfo)
        )

        assignDailySleepInfoArray()
    }
    
    private func makeNewDailySleepInfo() -> DailySleepInfo {
        let dreampetName = getRandomDreampetName()
        
        return DailySleepInfo(
            id: .init(),
            animalName: dreampetName,
            eggName: getRandomEggName(),
            // 만들어진 시점은 잠을 자기 시작한 시점이다.
            date: .now,
            sleepTimeInMinute: Int32(),
            // Processing 준비
            processStatus: .ready,
            assetName: dreampetName
        )
    }
}
