//
//  LofiAwakeView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/19.
//

import SwiftUI

struct LofiAwakeView: View {
    @State private var currentTime: Date = .now
    private let hourFormatter = DateFormatter(
        dateFormat: "H",
        calendar: .current
    )
    
    private let minuteFormatter = DateFormatter(
        dateFormat: "mm",
        calendar: .current
    )
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("지금 시간은 \n\(hourFormatter.string(from: currentTime))시 \(minuteFormatter.string(from: currentTime))분이에요.")
                    .font(.dosIyagiBold(.largeTitle))
                
                Spacer()
                
                Text("\(hourFormatter.string(from: currentTime))시간 \(minuteFormatter.string(from: currentTime))분 동안 알을 품었네요.\n잠은 충분히 주무셨나요?")
                    .font(.dosIyagiBold(.title3))
                    .padding()
                
                Text("화면을 다시 잠그면\n알을 더 품을 수 있어요.")
                    .font(.dosIyagiBold(.body))
                    .foregroundColor(.secondary)
                    .colorInvert()
                
                Spacer()
                
                NavigationLink {
                    LofiCurtainView()
                } label: {
                    Text("잘 잤어요!")
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

                NavigationLink {
                    Text("실패")
                } label: {
                    Text("잠이 안 와요ㅠ")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(.subButtonBlue)
                        .font(.dosIyagiBold(.body))
                }
                .background { Color.subButtonSky }
                .cornerRadius(8)
                .padding(.horizontal)
                
            }
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            
        }
    }
}

struct LofiAwakeView_Previews: PreviewProvider {
    static var previews: some View {
        LofiAwakeView()
    }
}
