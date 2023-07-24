//
//  MainEggsView.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/07/13.
//

import Combine
import SwiftUI

struct MainEggsView: View {
    
    // 남은시간
    @State var countDown: Int
    
    // 시간환산
    
    func convertTime(timeRemaining: Int) -> String {
        var hours: Int {
            Int((timeRemaining / 60) / 60)
        }
        
        var minutes: Int {
            Int((timeRemaining) / 60) % 60
        }
        
        var seconds: Int {
            Int(timeRemaining % 60)
        }
        
        return String(format: "%02i시간 %02i분 %02i초", hours, minutes, seconds)
    }
    
    // 타이머
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    
    // 타이머 연결과 관련된 옵셔널 보정같음..
    @State var connectedTimer: Cancellable? = nil
    
    // 타이머 실행 함수
    
    func exeTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
    }
    
    var body: some View {
        // 타이머 뷰
        Text(convertTime(timeRemaining: countDown))
            .onAppear {
                self.exeTimer()
            }
            .onReceive(timer) {
                _ in if countDown > 0 {
                    self.countDown -= 1
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}

struct MainEggsView_Previews: PreviewProvider {
    static var previews: some View {
        MainEggsView(countDown: 359)
    }
}

// 연산프로퍼티인
