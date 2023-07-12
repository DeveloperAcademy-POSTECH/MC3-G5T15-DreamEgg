//
//  LocalNotificationStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/12.
//

import SwiftUI
import UserNotifications

class LocalNotificationManager: ObservableObject {
    
    let notificationContent = UNMutableNotificationContent()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sleepNotification(userNotificationMessage: String, currentDate: Date) {
        notificationContent.title = "Dream Egg"
        notificationContent.subtitle = userNotificationMessage
        notificationContent.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let selectedDate = calendar.date(bySettingHour: calendar.component(.hour, from: currentDate), minute: calendar.component(.minute, from: currentDate), second: 0, of: calendar.startOfDay(for: currentDate))
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: calendar.dateComponents([.hour, .minute], from: selectedDate!),
            repeats: true
        )

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        notificationCenter.add(request)
    }
}
