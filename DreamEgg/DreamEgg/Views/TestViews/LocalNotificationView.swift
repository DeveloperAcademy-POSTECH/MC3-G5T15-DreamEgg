//
//  LocalNotificationView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/10.
//

import SwiftUI

struct LocalNotificationView: View {
    
    @StateObject
    private var localNotificationManager = LocalNotificationManager()
    
    @State private var currentDate = Date()
    @State private var userNotificationMessage = ""
    
    var body: some View {
        VStack {
            Button("Request Permission") {
                localNotificationManager.requestNotificationPermission()
            }
            
            DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
            
            TextField("미래의 나에게 할 말", text: $userNotificationMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Schedule Notification") {
                localNotificationManager.scheduleSleepNotification(userNotificationMessage: userNotificationMessage, selectedDate: currentDate)
            }
        }
    }
}

struct LocalNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotificationView()
    }
}
