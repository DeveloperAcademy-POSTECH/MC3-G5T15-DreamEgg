//
//  TimePickerModel.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/19.
//

import Foundation

final class TimePickerModel: ObservableObject {
    @Published var selectedHour = 10
    @Published var selectedMinute = 30
    @Published var selectedAMPM = 0
    
    let hourArr = Array(
        repeating: (1...12).map { $0 },
        count: 30
    )
        .flatMap({ array in
            return array
        })
    
    let minuteArr = Array(
        repeating: (0...59).map { $0 },
        count: 30
    )
        .flatMap({ array in
            return array
        })
    
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
//        selectedHour = (Int(strings[0]) ?? 1) + 12 * 10
//        selectedMinute = (Int(strings[1]) ?? 0) + 60 * 10
    }
}
