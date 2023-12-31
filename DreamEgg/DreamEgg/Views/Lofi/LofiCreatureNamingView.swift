//
//  LofiCreatureNamingView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiCreatureNamingView: View {
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    @Environment(\.presentationMode) var presentationMode
    @State private var dreampetName: String = ""
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Text("드림펫에게\n새로운 이름을 지어주세요.")
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .padding()
                    .lineSpacing(16)
                
                Spacer()
                    .frame(maxHeight: 145)
                
                HStack {
                    Text("안녕,")
                    
                    DETextField(style: .nameTextField, content: $dreampetName, maxLength: 10)
                    
                    Text("!")
                }
                .font(.dosIyagiBold(.body))
                
                Spacer()
                    .frame(maxHeight: 24)
                
                Text("이름은 언제든지\n다시 수정할 수 있어요.")
                    .font(.dosIyagiBold(.body))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(maxHeight: 276)
                
                VStack {
                    NavigationLink {
                        LofiNameConfirmView()
                    } label: {
                        Text("이렇게 지을래요.")
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
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                dailySleepTimeStore.updateDreamPetName(by: dreampetName)
                            }
                    )
                }
                
            }
            .padding(.top,68)
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .gesture(DragGesture().onChanged(onSwipeBack))
        .ignoresSafeArea(.keyboard)
    }
    
    // 뒤로 스와이프 하는 함수
    private func onSwipeBack(gesture: DragGesture.Value) {
        if gesture.location.x < 130 && gesture.translation.width > 80 {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct LofiCreatureNamingView_Previews: PreviewProvider {
    static var previews: some View {
        LofiCreatureNamingView()
    }
}
