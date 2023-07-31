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
    
    private let calendar: Calendar = Calendar.getCurrentCalendar()
    
    @Published public var dailySleepArray: [DailySleep] = []
    @Published public var currentDailySleep: DailySleep? {
        didSet {
            if let currentDailySleep {
                print("---------------------------------------------------------------------------")
                print("---------------------------------------------------------------------------")
                print("CURRENT DAILY SLEEP ID :", currentDailySleep.id ?? .init(uuidString: "id 없어?"))
                print("CURRENT DAILY SLEEP Status :", currentDailySleep.processStatus ?? "아직없음")
                print("CURRENT DAILY SLEEP Date :", currentDailySleep.date?.formatted() ?? "날짜없음")
                print("CURRENT DAILY SLEEP animalName :", currentDailySleep.animalName ?? "이름없음")
                print("CURRENT DAILY SLEEP EggName :", currentDailySleep.eggName ?? "알이없음")
                print("---------------------------------------------------------------------------")
                print("---------------------------------------------------------------------------")
            }
        }
    }
    
    // for calanedar
    @Published public var selectedDailySleep: DailySleep? {
        didSet {
            if let selectedDailySleep {
                print("---------------------------------------------------------------------------")
                print("---------------------------------------------------------------------------")
                print("SELECTED DAILY SLEEP ID :", selectedDailySleep.id ?? .init(uuidString: "id 없어?"))
                print("SELECTED DAILY SLEEP Status :", selectedDailySleep.processStatus ?? "아직없음")
                print("SELECTED DAILY SLEEP Date :", selectedDailySleep.date?.formatted() ?? "날짜없음")
                print("SELECTED DAILY SLEEP EggName :", selectedDailySleep.eggName ?? "알이없음")
                print("SELECTED DAILY SLEEP animalName :", selectedDailySleep.animalName ?? "이름없음")
                print("---------------------------------------------------------------------------")
                print("---------------------------------------------------------------------------")
            }
        }
    }
    
    @Published public var sleepDates: [Date] = []
    @Published public var sleptHour: Int = 0
    @Published public var sleptMinute: Int = 0
    @Published public var sleepingTimeInMinute: Int = 0
    
    // MARK: - LIFECYCLE
    init(coreDataStore: CoreDataStore = .releaseShared) {
        self.coreDataStore = coreDataStore
        self.sleepDates = self.dailySleepArray.compactMap { $0.date }
        assignDailySleepInfoArray()
        assignCurrentDailySleepFromArray()
        getSleepTimeInMinute()
        assignSleepingDailySleep()
    }
    
    // MARK: - Methods
    /// 실제로 유저가 잠에 들었던 시간을 가져옵니다.
    /// 잠에 들엇다는 플로우가 맨 마지막에 저장되어 있어야 함!
    public func getSleepTimeInMinute() {
        if let currentDailySleep,
           currentDailySleep.processStatus == Constant.SLEEP_PROCESS_SLEEPING {
            if let sleptTime = currentDailySleep.date {
                let sleptSecond = Int(sleptTime.distance(to: Date.now))
                self.sleepingTimeInMinute = sleptSecond / 60
                
                self.sleptHour = self.sleepingTimeInMinute / 60
                self.sleptMinute = self.sleepingTimeInMinute % 60
                print(#function, "잠든 분: ", sleepingTimeInMinute, "잠든 초: ", sleptSecond)
            }
        }
    }
}

// MARK: public Methos, Get
extension DailySleepTimeStore {
    public func getAssetNameSafely(isSelected: Bool = false) -> String {
        if isSelected,
           let selectedDailySleep,
           let assetName = selectedDailySleep.assetName {
            return assetName
        } else if let currentDailySleep,
           let assetName = currentDailySleep.assetName {
            return assetName
        } else {
            return Constant.Errors.NO_DREAMPET
        }
    }
    
    public func getAnimalNameSafely(isSelected: Bool = false) -> String {
        if isSelected,
           let selectedDailySleep,
           let dreampetName = selectedDailySleep.animalName {
            return dreampetName
        } else if let currentDailySleep,
           let animalName = currentDailySleep.animalName {
            return animalName
        } else {
            return Constant.Errors.NO_DREAMPET
        }
    }
    
    public func getDreampetBirthdaySafely(isSelected: Bool = false) -> Date {
        if isSelected,
           let selectedDailySleep,
           let date = selectedDailySleep.date {
            return date
        } else if let currentDailySleep,
           let date = currentDailySleep.date {
            return date
        } else {
            return .now
        }
    }
    
    public func getDreampetIncubateTimeSafely(isSelected: Bool = false) -> Int {
        if isSelected,
           let selectedDailySleep {
            return Int(selectedDailySleep.sleepTimeInMinute)
        } else if let currentDailySleep {
            return Int(currentDailySleep.sleepTimeInMinute)
        } else {
            return 0
        }
    }
    
    public func hasWellSleptDailySleep(
        in date: Date
    ) -> Bool {
        for dailySleepInfo in dailySleepArray {
            return Date.isSameDate(lhs: dailySleepInfo.date!, rhs: date) &&
            // 이 버전에선 1분
            dailySleepInfo.sleepTimeInMinute >= 1
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
    public func assignSleepingDailySleep() {
        print(#function, "FIND SLEEPING")
        let processing = self.dailySleepArray.filter {
            $0.processStatus == Constant.SLEEP_PROCESS_SLEEPING
        }
        
        if let currentDailySleep = processing.first {
            self.currentDailySleep = currentDailySleep
        }
    }
    
    // CoreData의 [DailySleep] 배열을 가져옵니다.
    private func assignDailySleepInfoArray() {
        self.dailySleepArray = Array(coreDataStore.dailySleep.values)
            .sorted(by: { lhs, rhs in
                lhs.date! > rhs.date!
            })
        
        print(#function, self.dailySleepArray)
    }
    
    // currentDailySleep에 최신 DailySleep을 할당합니다.
    private func assignCurrentDailySleepFromArray() {
        print(#function, dailySleepArray.first)
        self.currentDailySleep = self.dailySleepArray.first
    }
}


// MARK: COREDATA CRUD
extension DailySleepTimeStore {
    // CoreData에 할당하기 위한 속성들을 앱 모델에서 가져와서 할당합니다.
    internal func assignProperties(
        to coreData: DailySleep,
        from appEntityModel: DailySleepInfo
    ) {
        print(#function, appEntityModel)
        coreData.id = appEntityModel.id
        coreData.animalName = appEntityModel.animalName
        coreData.eggName = appEntityModel.eggName
        coreData.date = appEntityModel.date
        coreData.sleepTimeInMinute = appEntityModel.sleepTimeInMinute
        coreData.processStatus = appEntityModel.processStatus.description
        coreData.assetName = appEntityModel.assetName
    }
    
    /// 각 조건에 맞는 DailySleepInfo를 currentDailySleep에서 가져옵니다.
    /// - Parameter processStatus: 원하는 조건을 입력
    /// - Returns: DailySleepInfo
    private func getDailySleepInfo(
        in processStatus: DailySleepInfo.SleepProcessStatus
    ) -> DailySleepInfo {
        print(#function, processStatus)
        switch processStatus {
        case .ready:
            if let currentDailySleep {
                if currentDailySleep.processStatus == Constant.SLEEP_PROCESS_PROCESSING {
                    return self.getDailySleepInfo(in: .processing)
                } else if currentDailySleep.processStatus == Constant.SLEEP_PROCESS_SLEEPING {
                    return self.getDailySleepInfo(in: .sleeping)
                }
            } else {
                let newDailySleepInfo = makeNewDailySleepInfo()
                return newDailySleepInfo
            }
            
        case .processing:
            if let currentDailySleep,
               currentDailySleep.processStatus == Constant.SLEEP_PROCESS_PROCESSING {
                    let processingDailySleepInfo = DailySleepInfo(
                        from: currentDailySleep,
                        processStatus: .processing,
                        sleepingTimeInMinute: sleepingTimeInMinute
                    )
                    
                    return processingDailySleepInfo
                }
            
        case .sleeping:
            if let currentDailySleep,
               currentDailySleep.processStatus == Constant.SLEEP_PROCESS_SLEEPING {
                let sleepingDailySleepInfo = DailySleepInfo(
                    from: currentDailySleep,
                    processStatus: .sleeping,
                    sleepingTimeInMinute: sleepingTimeInMinute
                )
                
                return sleepingDailySleepInfo
            }
            
        case .stopped:
            if let currentDailySleep,
               currentDailySleep.processStatus == Constant.SLEEP_PROCESS_STOPPED {
                let stopped = DailySleepInfo(
                    from: currentDailySleep,
                    processStatus: .stopped,
                    sleepingTimeInMinute: sleepingTimeInMinute
                )
                
                return stopped
            }
            
        case .complete:
            if let currentDailySleep,
               currentDailySleep.processStatus == Constant.SLEEP_PROCESS_COMPLETE {
                let complete = DailySleepInfo(
                    from: currentDailySleep,
                    processStatus: .complete,
                    sleepingTimeInMinute: sleepingTimeInMinute
                )
                
                return complete
            }
        }

        return .getBlankDailySleepInfo()
    }
    
    /**
     coreDataStore에 model을 전달하여 update, save를 진행합니다.
     알을 완성하여 interaction 이 시작되는 시점에 호출합니다.
     */
    public func makeNewDailySleepToStartDailySleep() {
        print(#function, "START SLEEP FLOW")
        var newDailySleepInfo = getDailySleepInfo(in: .ready)
        newDailySleepInfo.processStatus = .processing
        
        updateAndAssignToCurrent(by: newDailySleepInfo)
    }
    
    /// processing 중인 dailySleep을 찾아 sleeping으로 업데이트합니다.
    /// 자러갈 때의 시작 시간을 현재로 변경해주고 sleeping 상태로 수정합니다.
    public func updateDailySleepTimeToNow() {
        print(#function)
        var model = self.getDailySleepInfo(in: .processing)
        model.processStatus = .sleeping
        model.date = .now
        updateAndAssignToCurrent(by: model)
    }
    
    /// dreampet의 이름을 변경합니다.
    /// - Parameters:
    ///     - by name: 변경할 이름
    ///     - isSelected: 현재 선택된 특정 dailySleep 을 변경하는지의 여부
    ///
    public func updateDreamPetName(
        by name: String,
        isSelected: Bool = false
    ) {
        if isSelected,
           let selectedDailySleep {
            print(#function, isSelected)
            var model = DailySleepInfo(
                from: selectedDailySleep,
                processStatus: .complete,
                sleepingTimeInMinute: Int(selectedDailySleep.sleepTimeInMinute)
            )
            
            model.animalName = name
            updateCoreData(with: model, predicate: getNSPredicate(with: model))
            assignDailySleepInfoArray()
            self.selectedDailySleep = coreDataStore.dailySleep[selectedDailySleep.id!]
        } else {
            print(#function, isSelected)
            // TODO: Complete가 맞네요~ ㅎ;
            var model = self.getDailySleepInfo(in: .complete)
            model.animalName = name
            updateAndAssignToCurrent(by: model)
        }
    }
    
    /// dailySleepInfo를 complete하고 시간을 할당합니다.
    /// @Published 되어 있는 self.currentDailySleepInfo를 참조합니다.
    /// DailySleepTime 은 각 entity의 id당 단 한번만 호출됩니다.
    public func completeDailySleepTime() {
        print(#function, self.currentDailySleep)
        var model = self.getDailySleepInfo(in: .sleeping)
        model.processStatus = .complete
        model.sleepTimeInMinute = Int32(sleepingTimeInMinute)
        print(#function, model)
        updateAndAssignToCurrent(by: model)
    }
    
    
    /// 수면 중이던 수면 플로우를 멈춘다.
    /// 이름들은 모두 새로 할당되며 process는 .stopped 상태로 업데이트 된다.
    public func updateDailyInfoProcessToStop() {
        print(#function)
        let sleptTime = sleepingTimeInMinute < 0 ? -1 : sleepingTimeInMinute
        var model = self.getDailySleepInfo(in: .sleeping)
        
        model.assetName = Constant.Errors.NO_DREAMPET
        model.animalName = Constant.Errors.NO_DREAMPET
        model.eggName = Constant.Errors.NO_EGG
        model.sleepTimeInMinute = Int32(sleptTime)
        model.processStatus = .stopped
        
        updateAndAssignToCurrent(by: model)
    }
    
    private func makeNewDailySleepInfo() -> DailySleepInfo {
        let dreampetName = getRandomDreampetName()
        
        return DailySleepInfo(
            id: .init(),
            animalName: dreampetName,
            eggName: getRandomEggName(),
            date: .now,
            sleepTimeInMinute: Int32(),
            // Processing 준비
            processStatus: .ready,
            assetName: dreampetName
        )
    }
    
    /// CoreData 에 저정할 dailySleepInfo를 받아서 업데이트 합니다.
    /// 업데이트된 후, store의 배열과 current에 자동으로 재할당 된 데이터를 업데이트 합니다.
    /// - Parameter dailySleepInfo: 업데이트 할 dailySleepInfo를 전달합니다.
    private func updateAndAssignToCurrent(by dailySleepInfo: DailySleepInfo) {
        print(#function, dailySleepInfo)
        updateCoreData(with: dailySleepInfo, predicate: getNSPredicate(with: dailySleepInfo))
        assignDailySleepInfoArray()
        assignCurrentDailySleepFromArray()
    }
}
