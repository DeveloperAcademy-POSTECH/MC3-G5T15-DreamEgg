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
                    .frame(maxHeight: 75)
                
                VStack {
                    Text("내일 나에게 할 말을 \n적어주세요.")
                        .foregroundColor(.white)
                        .font(.dosIyagiBold(.title))
                        .lineSpacing(16)
                        .padding()
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                
                Spacer()
                
                    DETextField(
                        style: .messageTextField,
                        content: $notificationMessage,
                        maxLength: 30
                    )
                    .offset(y: -50)
                
                Text("적어주신 문장으로\n취침 1시간 전에 알림을 드릴게요!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.6))
                    .lineSpacing(8)
                    .font(.dosIyagiBold(.body))
                
                Spacer()
                
                Button {
                    navigationManager.authenticateUserIntoGeneralState()
                    updateNotificationMessage()
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
                .padding()
                .disabled(notificationMessage.isEmpty)
                
                Button {
                    withAnimation {
                        navigationManager.authenticateUserIntoGeneralState()
                    }
                } label: {
                    Text("건너뛰기")
                        .foregroundColor(.white.opacity(0.6))
                        .underline(true)
                        .font(.dosIyagiBold(.callout))
                }
            }
            .onAppear {
                if let message = userSleepConfigStore.existingUserSleepConfig.notificationMessage {
                    self.notificationMessage = message
                }
            }
            .onDisappear {
                // notification 자체는 placeholder의 것으로 진행하되, UserSleepConfig가 notification 메세지를 보관하도록 함
                localNotificationManager.scheduleSleepNotification(
                    userNotificationMessage: notificationMessage,
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
