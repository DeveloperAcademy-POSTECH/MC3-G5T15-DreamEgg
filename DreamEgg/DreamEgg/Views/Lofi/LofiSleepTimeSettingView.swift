//
//  LofiSleepTimeSettingView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/22.
//

import SwiftUI

struct LofiSleepTimeSettingView: View {
    @StateObject private var sleepTimeStore: TimePickerModel = TimePickerModel()
    
    var body: some View {
        VStack {
            TimePickers(model: sleepTimeStore)
            
            Text("\(sleepTimeStore.selectedHour)")
        }
    }
}

struct LofiSleepTimeSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LofiSleepTimeSettingView()
    }
}
