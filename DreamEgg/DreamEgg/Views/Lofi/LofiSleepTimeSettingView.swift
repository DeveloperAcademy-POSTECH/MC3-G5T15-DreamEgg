//
//  LofiSleepTimeSettingView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/22.
//

import SwiftUI

struct LofiSleepTimeSettingView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var navigationManager: DENavigationManager
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    @EnvironmentObject var localNotificationManager: LocalNotificationManager
    
    @StateObject var timePickerStore: TimePickerStore = TimePickerStore()
    
    @State private var isAllowButtonTapped: Bool = false
    @State private var isNotificationAuthorized: Bool = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 40)
                
                Text(isNotificationAuthorized ? "잠들고 싶은\n희망 시간을 정해주세요." : "알림을 허용하면\n앱을 더 효과적으로\n이용할 수 있어요!")
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .lineSpacing(12)
                    .bold()
                    .padding()
                
                VStack(spacing: 24) {
                    TimePickerView(timePickerStore: timePickerStore)
                        .foregroundColor(.dreamPurple)
                    
                    Text("이후에도 시간을 수정할 수 있어요.")
                        
                }
                .frame(maxHeight: .infinity)
                .font(.dosIyagiBold(.body))
                
                
                if isNotificationAuthorized {
                    if navigationManager.viewCycle == .timeSetting,
                       navigationManager.isFromMainTab {
                        Button {
                            if let targetSleepTime = userSleepConfigStore.existingUserSleepConfig.targetSleepTime {
                                updateAndSaveSleepTime(with: targetSleepTime)
                            }
                            
                            navigationManager.viewCycle = .general
                            navigationManager.isFromMainTab = false
                        } label: {
                            Text("이렇게 수정할게요.")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.primaryButtonBrown)
                                .font(.dosIyagiBold(.body))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primaryButtonBrown, lineWidth: 5)
                                }
                        }
                        .background { Color.primaryButtonYellow }
                        .cornerRadius(8)
                        .padding()
                        
                    } else {
                        Button {
                            if let targetSleepTime = userSleepConfigStore.existingUserSleepConfig.targetSleepTime {
                                updateAndSaveSleepTime(with: targetSleepTime)
                            }
                            
                            withAnimation {
                                navigationManager.viewCycle = .notificationMessageSetting
                            }
                        } label: {
                            Text("이 시간에 잠에 들래요")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.primaryButtonBrown)
                                .font(.dosIyagiBold(.body))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primaryButtonBrown, lineWidth: 5)
                                }
                            
                        }
                        .background { Color.primaryButtonYellow }
                        .cornerRadius(8)
                        .padding()
                    }
                } else {
                    VStack(spacing: 10) {
                        Button {
                            isAllowButtonTapped = true
                        } label: {
                            Text("허용할게요.")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.primaryButtonBrown)
                                .font(.dosIyagiBold(.body))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primaryButtonBrown, lineWidth: 5)
                                }
                        }
                        .background { Color.primaryButtonYellow }
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.1), radius: 15, y: 5)
                        .alert("설정 창으로 이동합니다.", isPresented: $isAllowButtonTapped) {
                            alertButtons()
                        } message: {
                            Text("DreamEgg의 알람을 활성화해 주세요!")
                        }
                        
                        Button {
                            withAnimation {
                                navigationManager.viewCycle = .general
                            }
                        } label: {
                            Text("알림 없이 사용할게요.")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.subButtonBlue)
                                .font(.dosIyagiBold(.body))
                        }
                        .background { Color.subButtonSky }
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.1), radius: 15, y: 5)
                    }
                }
            }
            .onAppear {
                self.isNotificationAuthorized = localNotificationManager.hasNotificationStatusAuthorized == .authorized
                
                withAnimation {
                    localNotificationManager.requestNotificationPermission()
                }
            }
            .onChange(of: localNotificationManager.hasNotificationStatusAuthorized) { status in
                if status == .authorized { self.isNotificationAuthorized = true }
            }
        }
    }
    
    // MARK: Methods
    /// 사용자가 선택한 시간을 기존 CoreData에서 설정되어 있던 '시, 분'에 덮어씁니다.
    /// - Parameter targetSleepTime: Unwrapping된 CoreData SleepTime을 전달
    private func updateAndSaveSleepTime(with targetSleepTime: Date) {
        let isPm = (timePickerStore.timePickerElements.ampm.is == 1)
        
        var comps = Calendar.getCurrentCalendar()
            .dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: targetSleepTime
            )
        
        comps.hour = isPm
            ? timePickerStore.timePickerElements.hours.at % 12 + 12
            : timePickerStore.timePickerElements.hours.at % 12
        
        comps.minute = timePickerStore.timePickerElements.minutes.at % 60
        
        userSleepConfigStore.updateAndSaveUserSleepConfig(
            with: UserSleepConfigurationInfo(
                id: userSleepConfigStore.existingUserSleepConfig.id ?? .init(),
                targetSleepTime: Calendar.getCurrentCalendar().date(from: comps)!,
                notificationMessage: Constant.BASE_NOTIFICATION_MESSAGE
            )
        )
        
        print(
            "Starter Update",
            userSleepConfigStore.targetSleepTime.formatted(),
            "TARGET HOUR: ", "\(comps.hour!)"
        )
    }
    
    private func alertButtons() -> some View {
        VStack {
            Button(role: .cancel) {
                self.isAllowButtonTapped = false
            } label: {
                Text("취소")
            }
            
            Button {
                openURL(URL(string: UIApplication.openSettingsURLString)!)
            } label: {
                Text("설정하기")
            }
        }
    }
}

struct LofiSleepTimeSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LofiSleepTimeSettingView()
            .environmentObject(DENavigationManager())
            .environmentObject(UserSleepConfigStore())

    }
}
