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
    static let SLEEP_PROCESS_SLEEPING: String = "SLEEPING"
    static let SLEEP_PROCESS_COMPLETE: String = "COMPLETE"
    static let SLEEP_PROCESS_STOPPED: String = "STOPPED"
    
    static let GOODNIGHT_PREPARE_MESSAGES: [String] = [
        "잠들기 전,\n치카치카는 필수!",
        "오늘도, 내일도\n빠짐없이 잘 자기",
        "다음엔 만날\n드림펫은 누굴까?",
        "이 행운의 편지는\n드림월드에서 시작되어...",
        "기상천외한 드림펫도\n숨어있다고?👀",
    ]
    
    enum Errors {
        static let NO_EGG: String = "NoEgg"
        static let NO_DREAMPET: String = "NoDreampet"
    }
    
    enum DreamPets {
        static var DREAMPET_NAME_SET: Set<String> = Set(
            [
                "Quakka",
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
