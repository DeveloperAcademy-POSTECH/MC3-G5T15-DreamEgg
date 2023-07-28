//
//  LocalNotificationStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/12.
//

import Combine
import SwiftUI
import UserNotifications

final class LocalNotificationManager: NSObject, ObservableObject {
    @Published var hasNotificationStatusAuthorized: UNAuthorizationStatus? = nil
    
    private let notificationContent = UNMutableNotificationContent()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let calendar = Calendar.getCurrentCalendar()
    
    // MARK: Methods
    public func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { allowed, error in
            if allowed {
                // MARK: Notification Request
                self.getNotificationstatus()
            }
            else if !allowed {
                self.getNotificationstatus()
            }
            else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func getNotificationstatus() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.hasNotificationStatusAuthorized = settings.authorizationStatus
            }
        }
    }
    
    public func scheduleSleepNotification(
        userNotificationMessage: String,
        selectedDate: Date
    ) {
        initNotificationCenter()
        makeNotificationContent(with: userNotificationMessage)
        let notificationDate = configNotificationDate(with: selectedDate)
        let request = makeScheduledNotificationRequest(with: notificationDate)
        
        notificationCenter.add(request)
        notificationCenter.getPendingNotificationRequests { messages in
            print("Notification Schdule Complete: ", messages)
        }
    }
    
    private func initNotificationCenter() {
        // MARK: 기존 알람을 모두 지워야 함
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.delegate = self
        
    }
    
    private func makeNotificationContent(with message: String) {
        notificationContent.title = "Dream Egg"
        notificationContent.subtitle = message
        notificationContent.sound = UNNotificationSound.default
    }
    
    private func configNotificationDate(with selectedDate: Date) -> Date {
        let notificationDate = calendar.date(
            // 선택한 날짜가 현재시간 이전이라면
            bySettingHour: selectedDate.hour - 1,
            minute: selectedDate.minute,
            second: 0,
            of: calendar.startOfDay(for: selectedDate)
        )
        
        if let notificationDate { return notificationDate }
        else { return .now }
    }
    
    private func makeScheduledNotificationRequest(with date: Date) -> UNNotificationRequest {
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: calendar.dateComponents(
                [.hour, .minute],
                from: date
            ),
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: Constant.DREAMEGG_NOTIFICATION_ID,
            content: notificationContent,
            trigger: trigger
        )
        
        return request
    }
}

// MARK: - UNUserNotificationCenterDelegate

/// Foreground Notification
/// in case, navigate to DEMainEggView
extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("identifier:\(notification.request.identifier)")
        completionHandler([.alert, .sound, .badge])
    }
}
