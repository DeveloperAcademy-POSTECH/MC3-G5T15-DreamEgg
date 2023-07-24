//
//  LofiSleepTimeSettingView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/22.
//

import SwiftUI

struct LofiSleepTimeSettingView: View {
    @EnvironmentObject var navigationManager: DENavigationManager
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    @StateObject var timePickerStore: TimePickerStore = TimePickerStore()
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 40)
                
                Text("잠들고 싶은\n희망 시간을 정해주세요.")
                    .font(.dosIyagiBold(.title2))
                    .multilineTextAlignment(.center)
                    .lineSpacing(12)
                    .bold()
                    .padding()
                
                VStack {
                    Text("이후에도 시간을 수정할 수 있어요.")
                    
                    Text("이 시간이 되기 1시간 전에 알람을 보내드릴게요!")
                }
                .font(.dosIyagiBold(.footnote))
                
                TimePickerView(timePickerStore: timePickerStore)
                    .foregroundColor(.dreamPurple)
                    .frame(maxHeight: .infinity)
                
                if navigationManager.viewCycle == .timeSetting {
                    Button {
                        if let targetSleepTime = userSleepConfigStore.existingUserSleepConfig.targetSleepTime {
                            print("??")
                            updateAndSaveSleepTime(with: targetSleepTime)
                        }
                        
                        print("Time Reset Update", userSleepConfigStore.targetSleepTime.formatted())
                        
                        navigationManager.viewCycle = .general
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
                    NavigationLink(value: userSleepConfigStore.targetSleepTime) {
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
                    .navigationDestination(for: Date.self) { _ in
                        LofiTextCustomView()
                    }
                    .background { Color.primaryButtonYellow }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                if let targetSleepTime = userSleepConfigStore.existingUserSleepConfig.targetSleepTime {
                                    updateAndSaveSleepTime(with: targetSleepTime)
                                }
                                
                                print("Starter Update", userSleepConfigStore.existingUserSleepConfig.targetSleepTime?.formatted())
                            }
                    )
                    .cornerRadius(8)
                    .padding()
                }
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
            ? timePickerStore.timePickerElements.hours.at % 20 + 12
            : timePickerStore.timePickerElements.hours.at % 20 - 12
        
        comps.minute = timePickerStore.timePickerElements.minutes.at % 60
        
        userSleepConfigStore.updateAndSaveUserSleepConfig(
            with: UserSleepConfigurationInfo(
                id: userSleepConfigStore.existingUserSleepConfig.id ?? .init(),
                targetSleepTime: Calendar.getCurrentCalendar().date(from: comps)!,
                notificationMessage: Constant.BASE_NOTIFICATION_MESSAGE
            )
        )
    }
}

//struct LofiSleepTimeSettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LofiSleepTimeSettingView()
//    }
//}
