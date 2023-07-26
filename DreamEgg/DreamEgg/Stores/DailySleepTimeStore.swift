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
    @Published public var currentDailySleep: DailySleep?
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
    public func getProcessingDailySleepInfo() -> DailySleepInfo {
        if let currentDailySleep,
           currentDailySleep.processStatus == Constant.SLEEP_PROCESS_PROCESSING.description
        {
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
    
    /// 현재 진행중인 수면 과정을 찾아서 self.currentDailySleep에 할당합니다.
    /// 이후, currentDailySleep을 바탕으로 앱 분기처리를 진행합니다.
    /// 이 메소드는 앱이 완전히 꺼지고 suspend 되었다가 active될 때만 속성을 할당합니다.
    private func assignDailySleepProcessing() {
        let processing = self.dailySleepArray.filter {
            $0.processStatus == DailySleepInfo.SleepProcessStatus.processing.description
        }
        
        if let currentDailySleep = processing.first {
            self.currentDailySleep = currentDailySleep
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
    
    public func getSleepTimeInMinute() {
        if let sleptTime = self.currentDailySleep?.date {
            let sleptSecond = Int(sleptTime.distance(to: Date.now))
            self.sleepingTimeInMinute = sleptSecond / 60
            
            self.sleptHour = self.sleepingTimeInMinute / 60
            self.sleptMinute = self.sleepingTimeInMinute % 60
        }
    }
    
    private func getRandomDreampetName() -> String {
        let usersAnimalName = Set(
            dailySleepArray.filter {
                // CoreData에 저장된 stopped의 이름은 다시 사용이 가능하다.
                $0.processStatus == Constant.SLEEP_PROCESS_PROCESSING ||
                $0.processStatus == Constant.SLEEP_PROCESS_COMPLETE
            }
                .map {
                    $0.animalName!
                }
        )
        
        let availableNames = Constant.DreamPets.DREAMPET_NAME_SET.subtracting(
            usersAnimalName
        )
        
        return Array(availableNames).randomElement() ?? "없다고!"
    }
    
    private func getRandomEggName() -> String {
        let usersEggName = Set(
            dailySleepArray.filter {
                // CoreData에 저장된 stopped의 이름은 다시 사용이 가능하다.
                $0.processStatus == Constant.SLEEP_PROCESS_PROCESSING ||
                $0.processStatus == Constant.SLEEP_PROCESS_COMPLETE
            }
                .map {
                    $0.eggName!
                }
        )
        
        let availableEggs = Constant.DreamPets.DREAMPET_EGGNAME_SET.subtracting(
            usersEggName
        )
        
        return Array(availableEggs).randomElement() ?? "없다!"
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
    /**
     coreDataStore에 model을 전달하여 update, save를 진행합니다.
     잠을 자는 플로우가 시작되는 시점에 트리거되며
     processStatus를 processing으로 수정할당합니다.
     */
    public func updateAndSaveNewDailySleepInfo() {
        var model = makeNewDailySleepInfo()
        model.processStatus = .processing
        
        updateCoreData(
            with: model,
            predicate: getNSPredicate(with: model)
        )
        
        assignDailySleepInfoArray()
    }
    
    
    /// dailySleepInfo를 complete하고 시간을 할당합니다.
    /// @Published 되어 있는 self.currentDailySleepInfo를 참조합니다.
    public func completeDailySleepTime() {
        var model = self.getProcessingDailySleepInfo()
        model.processStatus = .complete
        model.sleepTimeInMinute = Int32(sleepingTimeInMinute)
        
        print(#function, model)
        
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
        
        if let currentDailySleep {
            // 현재 추적중인 CoreData의 DailySleep의 id를 그대로 copy해서 저장시킨다.
            dailySleepInfo.id = currentDailySleep.id!
            dailySleepInfo.date = currentDailySleep.date!
            dailySleepInfo.animalName = currentDailySleep.animalName!
            dailySleepInfo.eggName = currentDailySleep.eggName!
            dailySleepInfo.sleepTimeInMinute = Int32(sleptTime)
            dailySleepInfo.processStatus = .stopped
            dailySleepInfo.assetName = currentDailySleep.assetName!
        }
        
        updateCoreData(
            with: dailySleepInfo,
            predicate: getNSPredicate(with: dailySleepInfo)
        )
        
        assignDailySleepInfoArray()
    }
    
    private func assignDailySleepInfoArray() {
        self.dailySleepArray = Array(coreDataStore.dailySleep.values)
            .sorted(by: { lhs, rhs in
                lhs.date! > rhs.date!
            })
        
        self.currentDailySleep = self.dailySleepArray.first
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
