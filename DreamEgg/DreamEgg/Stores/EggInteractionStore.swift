//
//  EggInteractionStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/13.
//

import SwiftUI

class EggInteraction: ObservableObject {
    
}

struct PendulumAnimation: View {
    @State private var rotationAngle: Angle = .degrees(0.0)
    @State private var direction: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    @State private var isLongPress = false
    let imageName: String
    let amplitude: CGFloat
    let animationDuration: Double
    let width = UIScreen.main.bounds.size.width

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(rotationAngle, anchor: .bottom)
            .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true), value: rotationAngle)
            .gesture(DragGesture()
                .onChanged { value in
                    let dragAngle = Angle(radians: Double(value.translation.width) * 0.01)
                    let newRotationAngle = Angle.degrees(amplitude * Double(direction)) + dragAngle
                                        rotationAngle = clampRotationAngle(newRotationAngle)
                }
                .onEnded { value in
                    rotationAngle = .degrees(0)
                }
            )
            .onLongPressGesture {
                isLongPress = true
                rotationAngle = .degrees(0)
            }
            .onAppear {
                startPendulumAnimation()
            }
    }

    private func startPendulumAnimation() {
        withAnimation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
            rotationAngle = .degrees(amplitude * direction)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            direction *= -1
            rotationAngle = .degrees(0)
            if !isLongPress {
                startPendulumAnimation()
            }
        }
    }
    
    private func clampRotationAngle(_ angle: Angle) -> Angle {
            let clampedAngle = min(max(angle.degrees, -90.0), 90.0)
            return .degrees(clampedAngle)
        }
}
