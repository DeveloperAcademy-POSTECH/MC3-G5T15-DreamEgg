//
//  LofiTextCustomView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/19.
//

import SwiftUI

struct LofiTextCustomView: View {
    @EnvironmentObject var navigationManager: DENavigationManager
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    @EnvironmentObject var localNotificationManager: LocalNotificationManager
    @State private var notificationMessage: String = ""
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                
//                VStack {
                Text("내일 나에게 할 말을 \n적어주세요.")
                    .font(.dosIyagiBold(.title))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(16)
                    .tracking(-3)
                
//                        .padding()
//
//                    Text("기존 알림 대신에 적어주신 문장으로 알림을 드릴게요!")
//                        .font(.dosIyagiBold(.body))
//                }
//                .multilineTextAlignment(.center)
//                .foregroundColor(.white)
//
//                Spacer()
                
//                HStack {
//                    Text("내일은")
                    
                    // MARK: Design System으로 변경 예정
                
                VStack {
                    Spacer()
                        .frame(maxHeight: 88)
                    
                    DETextField(style: .messageTextField, content: $notificationMessage, maxLength: 30)
//                        .offset(y: -50)
                    
                    Spacer()
                        .frame(maxHeight: 80)
                
                    Text("적어주신 문장으로\n취침 1시간 전에 알림을 드릴게요!")
                        .font(.dosIyagiBold(.body))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .tracking(-2)
                }
                .frame(maxHeight: .infinity)
                    
//                    TextField(text: $notificationMessage) {
//                        Text("입력")
//                    }
//                    .multilineTextAlignment(.center)
//                    .frame(
//                        maxWidth: 125,
//                        maxHeight: 50
//                    )
//                    .background {
//                        Capsule()
//                            .fill(Color.subButtonSky)
//                    }
//                    .padding(8)
//                    
//                    Text("하는 날!")
//                }
//                .font(.dosIyagiBold(.body))
                
                Spacer()
                
                Button {
                    withAnimation {
                        navigationManager.authenticateUserIntoGeneralState()
                    }
                } label: {
                    Text("이렇게 알림을 보내주세요.")
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
                .disabled(notificationMessage.isEmpty)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            if !notificationMessage.isEmpty {
                                updateNotificationMessage()
                            }
                        }
                )
                
                Button {
                    withAnimation {
                        navigationManager.authenticateUserIntoGeneralState()
                    }
                } label: {
                    Text("건너뛰기")
                        .foregroundColor(.white.opacity(0.6))
                        .underline(true)
                        .font(.dosIyagiBold(.callout))
                        .padding(.vertical, 16)
                }
            }
            .onDisappear {
                localNotificationManager.scheduleSleepNotification(
                    userNotificationMessage: userSleepConfigStore.notificationMessage,
                    selectedDate: userSleepConfigStore.targetSleepTime
                )
            }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            self.endTextEditing()
        }
        .navigationBarBackButtonHidden()
    }
    
    private func updateNotificationMessage() {
        let existingConfig = userSleepConfigStore.existingUserSleepConfig
        
        userSleepConfigStore.updateAndSaveUserSleepConfig(
            with: UserSleepConfigurationInfo(
                id: existingConfig.id ?? .init(),
                targetSleepTime: existingConfig.targetSleepTime!,
                notificationMessage: notificationMessage
            )
        )
    }
}

struct LofiTextCustomView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LofiTextCustomView()
        }
    }
}
