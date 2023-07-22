//
//  DailySleepTimeStore.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/11.
//

import SwiftUI

final class DailySleepTimeStore: ObservableObject {
    @Published private var coreDataStore: CoreDataStore = .debugShared
    @Published public var dailySleepDict: Dictionary<UUID, DailySleep> = [:]
    
    public var dailySleepArr: [DailySleep] {
        Array(dailySleepDict.values)
    }
    
    // MARK: LIFECYCLE
    init(coreDataStore: CoreDataStore = .debugShared) {
        self.coreDataStore = coreDataStore
        self.dailySleepDict = coreDataStore.dailySleep
    }
    
    // MARK: Methods
    /**
     coreDataStore에 model을 전달하여 update, save를 진행합니다.
     */
    public func updateAndSave(with model: DailySleepInfo) {
        coreDataStore.updateAndSaveDailySleep(with: model)
        assignDailySleepDict()
    }
    
    private func assignDailySleepDict() {
        self.dailySleepDict = coreDataStore.dailySleep
        print(#function, self.dailySleepDict, coreDataStore.dailySleep)
    }
}
