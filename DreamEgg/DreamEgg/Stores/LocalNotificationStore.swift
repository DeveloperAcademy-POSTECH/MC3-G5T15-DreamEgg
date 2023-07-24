//
//  LocalNotificationStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/12.
//

import Combine
import SwiftUI
import UserNotifications

class LocalNotificationManager: ObservableObject {
    @Published var hasNotificationStatusAuthorized: UNAuthorizationStatus? = nil
    
    let notificationContent = UNMutableNotificationContent()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                // MARK: Notification Request
                self.getNotificationstatus()
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getNotificationstatus() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.hasNotificationStatusAuthorized = settings.authorizationStatus
            }
        }
    }
    
    func sleepNotification(userNotificationMessage: String, selectedDate: Date) {
        notificationContent.title = "Dream Egg"
        notificationContent.subtitle = userNotificationMessage
        notificationContent.sound = UNNotificationSound.default
        
        let calendar = Calendar.getCurrentCalendar()
        let notificationDate = calendar.date(
            // 선택한 날짜가 현재시간 이전이라면
            bySettingHour: selectedDate.hour - 1,
            minute: selectedDate.minute,
            second: 0,
            of: calendar.startOfDay(for: selectedDate)
        )
        
        print("NOTIFICATION_DATE", notificationDate!)
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: calendar.dateComponents(
                [.hour, .minute],
                from: notificationDate ?? .now
            ),
            repeats: true
        )

//        let request = UNNotificationRequest(
//            identifier: Constant.DREAMEGG_NOTIFICATION_ID,
//            content: notificationContent,
//            trigger: trigger
//        )
//
//        notificationCenter.add(request)
    }
}
