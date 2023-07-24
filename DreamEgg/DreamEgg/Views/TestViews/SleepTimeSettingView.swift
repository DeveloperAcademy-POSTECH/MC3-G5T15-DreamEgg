//
//  SleepTimeSettingView.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/07/13.
//

import SwiftUI

struct SleepTimeSettingView: View {
    @EnvironmentObject var userSleepConfigStore: UserSleepConfigStore
    
    // 취침시간
    @State private var sleepTime = Date()
    
    // 취침시간 포매팅
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh시 mm분 ss초"
        return formatter
    }
    
    // DatePicker(in: 범위)
    var timeRange: ClosedRange<Date> {
        let minTime = Date.distantPast
        let maxTime = Date.distantFuture
        return minTime...maxTime
    }
    
    // 남은시간
    var timeRemaining: Int {
        var time = Int(sleepTime.timeIntervalSince(.now))
        
        if time < 0 {
            time = Int(sleepTime.timeIntervalSince(.now)) + 86400
            return time
        } else {
            let time = Int(sleepTime.timeIntervalSince(.now))
            return time
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("매일 잠들 시간을 정해주세요.")
                    .font(.dosIyagiBold(.title2))
                    .multilineTextAlignment(.center)
                    .bold()
                
                ZStack {
                    // 데이트피커 커스텀
                    DatePicker("", selection: $sleepTime, in: timeRange, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                        .frame(width: 220, height: 200)
                        .clipped()
                        .background(Color(UIColor.systemGray6).cornerRadius(16).shadow(radius: 4, x: 4, y: 4).opacity(0.4))
                        .padding()
                }
                
                VStack {
                    Text("이후에 시간을 수정할 수 있습니다.")
                    
                    Text("이 시간이 되기 1시간 전에 알람을 보내드릴게요!")
                }
                    .font(.dosIyagiBold(.footnote))
                
                Spacer()
                
                NavigationLink {
//                    MainEggsView(countDown: timeRemaining)
                    LofiTextCustomView()
                } label: {
                    Text("이 시간에 잠에 들래요")
                        .font(.dosIyagiBold(.body))
                        .frame(width: 260, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            userSleepConfigStore.existingUserSleepConfig.targetSleepTime = sleepTime
                        }
                )
            }
        }
        .onChange(of: sleepTime) { newValue in
            print(newValue.formatted())
        }
    }
}

struct SleepTimeSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SleepTimeSettingView()
    }
}

// 문제점과 키워드 및 로직

// 데이트피커 설정범위에 따른 -값 보정
// if 문으로 조건을 나눠서 0보다 작은 범주에 따른 숫자값을 + 86400으로 보정
// ex. -60초를 +86400, formatter로 23시간 59분으로 보정

// 연산 프로퍼티의 값 변경 불가
// get-only property의 {} 내에 것을 연산하여 보여주는 대신, {} 외 외부 연산에 대한건 프로퍼티의 특성상 값을 변경할 수 없다.
// 다른 뷰로 넘겨야하는 값의 경우 저장 프로퍼티로 넘겨서 값을 변경시킬 수 있다.
// MainEggsView 참고

