//
//  LofiAwakeView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/19.
//

import SwiftUI

struct LofiAwakeView: View {
    @State private var currentTime: Date = .now
    @State var maskColor = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8))

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
//                Text("It's \(hourFormatter.string(from: currentTime)):\(minuteFormatter.string(from: currentTime)) now")
                .font(.dosIyagiBold(.largeTitle))
// 추후 수면시간 대비 분기처리를 위한 if 구조를 만들어두었습니다.
                if currentTime == currentTime {
                    Image("EggPillow")
                        .resizable()
                        .frame(width: 160, height: 160)
                        .padding(.top, 170)
                        .overlay(
                        Image("FerretEgg")
                            .resizable()
                            .frame(width: 160, height: 160)
                    )
                    // 나중에 currentTime 대신에 수면 시간 값이 들어가야 함.
                    Text("\(hourFormatter.string(from: currentTime))시간 \(minuteFormatter.string(from: currentTime))분 동안 알을 품었네요.\n잠은 충분히 주무셨나요?")
                    //                Text("You incubate the egg for \(hourFormatter.string(from: currentTime)):\(minuteFormatter.string(from: currentTime))")
                    .font(.dosIyagiBold(.title3))
                        .padding()

                    Text("이제 알의 변화를 살필 수 있어요.")
                    //                Text("If you lock the screen again\nYou can incubte the egg more.")
                    .font(.dosIyagiBold(.body))
                        .foregroundColor(.secondary)
                        .colorInvert()

                    Spacer()

                    NavigationLink {
                        LofiCurtainView()
                    } label: {
                        Text("잘 잤어요!")
                        //                    Text("I slept well!")
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
                } else {
                    Spacer()
                    Image("FerretEgg")
                        .resizable()
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(90))
                        .overlay(
                        Image("EggHat")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(60))
                            .padding(.bottom, 80)
                            .padding(.leading, 180)
                    )
                        .overlay(
                        Image("EggPillow")
                            .resizable()
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-25))
                            .padding(.bottom, 80)
                            .padding(.trailing, 40)
                    )
                        .overlay(
                        Rectangle()
                            .fill(maskColor)
                            .frame(width: 300, height: 300)
                    )

                    Spacer()
                    // 나중에 currentTime 대신에 수면 시간 값이 들어가야 함.
                    Text("\(hourFormatter.string(from: currentTime))시간 \(minuteFormatter.string(from: currentTime))분 동안 알을 품었네요.\n좀 더 주무셔야겠어요.")
                    //                Text("You incubate the egg for \(hourFormatter.string(from: currentTime)):\(minuteFormatter.string(from: currentTime))")
                    .font(.dosIyagiBold(.title3))
                        .padding()

                    Text("화면을 다시 잠그면\n알을 더 오래 품을 수 있어요.")
                    //                Text("If you lock the screen again\nYou can incubte the egg more.")
                    .font(.dosIyagiBold(.body))
                        .foregroundColor(.secondary)
                        .colorInvert()

                    Spacer()

                    NavigationLink {
                        Text("실패")
                        //                    Text("To Fail screen")
                    } label: {
                        Text("아직도 잠을 못잤어요.")
                        //                    Text("I don't feel like to sleep")
                        .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.subButtonBlue)
                            .font(.dosIyagiBold(.body))
                    }
                        .background { Color.subButtonSky }
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
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
