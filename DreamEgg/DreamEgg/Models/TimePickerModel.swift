//
//  TimePickerModel.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/19.
//

import Foundation

final class TimePickerModel: ObservableObject {
    @Published var selectedHour = 1
    @Published var selectedMinute = 0
    @Published var selectedAMPM = 0
    let hoursRange = 1 ... 12 * 20
    let minutesRange = 0 ... (59 + 1) * 20
    let AMPMRange = 0 ... 1
    
    init() {
        let presentTime = DateFormatter()
        let today = Date()
        var strings : [String]
        presentTime.locale = Locale(identifier: "ko_KR")
        presentTime.dateStyle = .none
        presentTime.timeStyle = .short
        strings = presentTime.string(from: today).components(separatedBy: .whitespaces)
        
        if strings[0] == "오전" {
            selectedAMPM = 0
        }
        
        else {
            selectedAMPM = 1
        }
        
        strings = strings[1].components(separatedBy: ":")
        selectedHour = (Int(strings[0]) ?? 1) + 12 * 10
        selectedMinute = (Int(strings[1]) ?? 0) + 60 * 10
        
    }
}
