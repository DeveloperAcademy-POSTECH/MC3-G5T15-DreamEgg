//
//  LocalNotificationView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/10.
//

import SwiftUI
import UserNotifications

struct LocalNotificationView: View {
    @State private var currentDate = Date()
    @State private var userNotificationMessage = ""
    
    var body: some View {
        VStack {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
            
            TextField("미래의 나에게 할 말", text: $userNotificationMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Schedule Notification") {
                let content = UNMutableNotificationContent()
                content.title = userNotificationMessage
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default
                
                let calendar = Calendar.current
                let selectedDate = calendar.date(bySettingHour: calendar.component(.hour, from: currentDate), minute: calendar.component(.minute, from: currentDate), second: 0, of: calendar.startOfDay(for: currentDate))
                
                var dateComponents = calendar.dateComponents([.hour, .minute], from: selectedDate!)
                dateComponents.calendar = calendar
                
                
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents,
                    repeats: true
                )

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request)
                
            }
        }
    }
}

struct LocalNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotificationView()
    }
}
