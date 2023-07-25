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
    @State private var eggTab = false
    @State private var isButtonDisabled = false

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

                // 추후 수면시간 대비 분기처리를 위한 if 구조.
                if currentTime != currentTime {
                    ZStack {
                        /** egg를 탭하면 eggtab의 값이 toggle되어 confetti가 적용 된 sparkle 이미지가 나타나고, 3초간 버튼 기능을 비활성합니다. 3초 후에는 각 토글을 다시 false로 전환합니다. */
                        Button(action: {
                            if !isButtonDisabled {
                                eggTab = true
                                isButtonDisabled = true

                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    isButtonDisabled = false
                                    eggTab = false
                                }
                            }
                        }) {
                            Image("EggPillow")
                                .resizable()
                                .frame(width: 160, height: 160)
                                .padding(.top, 170)
                                .overlay(
                                Image("FerretEgg")
                                    .resizable()
                                    .frame(width: 160, height: 160)
                            )

                        }
                            .disabled(isButtonDisabled)

                        if eggTab {
                            Image("ShinyMiddle")
                                .modifier(ParticlesModifier())
                        }
                    }

                    // 추후 currentTime 대신에 수면 시작 시간으로부터 누적 된 값이 들어가야 함.
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

                        .overlay(
                        Text("Zzz...")
                            .font(.dosIyagiBold(.callout))
                            .padding(.top, 70)
                            .padding(.leading, 110)
                    )

                    Spacer()

                    // 추후 currentTime 대신에 수면 시작 시간으로부터 누적 된 값이 들어가야 함.
                    Text("\(hourFormatter.string(from: currentTime))시간 \(minuteFormatter.string(from: currentTime))분 동안 알을 품었네요.\n좀 더 주무셔야겠어요.")
//                  Text("You incubate the egg for \(hourFormatter.string(from: currentTime)):\(minuteFormatter.string(from: currentTime))")
                    .font(.dosIyagiBold(.title3))
                        .padding()

                    Text("화면을 다시 잠그면\n알을 더 오래 품을 수 있어요.")
//                  Text("If you lock the screen again\nYou can incubte the egg more.")
                    .font(.dosIyagiBold(.body))
                        .foregroundColor(.secondary)
                        .colorInvert()

                    Spacer()

                    NavigationLink {
                        Text("실패")
//                      Text("To Fail screen")
                    } label: {
                        Text("아직도 잠을 못잤어요.")
//                      Text("I don't feel like to sleep")
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

/** confetti 애니메이션에 대한 설정 1 */
struct FireworkParticlesGeometryEffect: GeometryEffect {
    var time: Double
    var speed = Double.random(in: 20 ... 200)
    var direction = Double.random(in: -Double.pi ... Double.pi)

    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}

/** confetti에 애니메이션에 대한 설정 2 */
struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 5.0

    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<80, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration - time) / duration))
            }
        }
            .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}

struct LofiAwakeView_Previews: PreviewProvider {
    static var previews: some View {
        LofiAwakeView()
    }
}
