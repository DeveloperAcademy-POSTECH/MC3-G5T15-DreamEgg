//
//  Constants.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/22.
//

import Foundation

public enum Constant {
    static let BASE_NOTIFICATION_MESSAGE = "오늘의 알을 품고 목표한 시간에 잠을 자볼까요?"
    static let BASE_TARGET_SLEEP_TIME = Date.now
    static let DREAMEGG_NOTIFICATION_ID = "DreamEggNotificationID"
   
    static let SLEEP_PROCESS_READY: String = "READY"
    static let SLEEP_PROCESS_PROCESSING: String = "PROCESSING"
    static let SLEEP_PROCESS_COMPLETE: String = "COMPLETE"
    static let SLEEP_PROCESS_STOPPED: String = "STOPPED"
    
    enum DreamPets {
        static var DREAMPET_NAME_SET: Set<String> = Set(
            [
                "Quokka",
                "Rabbit",
            ]
        )
        
        static var DREAMPET_EGGNAME_SET: Set<String> = Set(
            [
                "BinyEgg",
                "FerretEgg",
            ]
        )
    }
}
