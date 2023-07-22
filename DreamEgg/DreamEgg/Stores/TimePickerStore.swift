//
//  TimePickerStore.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/22.
//

import Foundation

private let iterationNum = 20

class TimePickerStore: ObservableObject {
    @Published var selectedElements = [
        1, // Hours
        0, // Minutes
        0, // AMPM
    ]
    let ranges = [
        1 ... 12 * iterationNum, // Hours
        0 ... (59 + 1) * iterationNum,  // Minutes
        0 ... 1, // AMPM
    ]
    
    init() {
        let presentTime = DateFormatter()
        let today = Date()
        var strings : [String]
        presentTime.locale = Locale(identifier: "ko_KR")
        presentTime.dateStyle = .none
        presentTime.timeStyle = .short
        strings = presentTime.string(from: today).components(separatedBy: .whitespaces)
        
        if strings[0] == "오전" {
            selectedElements[2] = 0
        }
        
        else {
            selectedElements[2] = 1
        }
        
        strings = strings[1].components(separatedBy: ":")
        selectedElements[0] = (Int(strings[0]) ?? 1) + 12 * 10
        selectedElements[1] = (Int(strings[1]) ?? 0) + 60 * 10
    }
    
    func transformToString(num: Int, pickerType: String) -> String {
        switch pickerType {
        case "hour":
            if num % 12 == 0 {
                return "12"
            }
            else {
                return String(format: "%02d", num % 60)
            }
            
        case "minute":
            return String(format: "%02d", num % 60)
            
            
        case "ampm":
            if num == 0 {
                return "AM"
            }
            else {
                return "PM"
            }
            
        default :
            return ""
        }
    }
}
