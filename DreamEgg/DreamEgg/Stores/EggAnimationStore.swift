//
//  EggInteractionStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/13.
//

import SwiftUI

class EggAnimation: ObservableObject {
    static let shared = EggAnimation()
    @Published var rotationAngle: Angle = .degrees(0.0)
    @Published private var direction: CGFloat = 1.0
    @Published private var dragOffset: CGSize = .zero
    @Published private var isLongPress = false
    
    private init() {}

    func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                self.isLongPress = true
                let dragAngle = Angle(radians: Double(value.translation.width) * 0.01)
                let newRotationAngle = Angle.degrees(10.0 * Double(self.direction)) + dragAngle
                self.rotationAngle = self.clampRotationAngle(newRotationAngle)
            }
            .onEnded { value in
                self.rotationAngle = .degrees(0)
                self.isLongPress = false
                self.startPendulumAnimation()
            }
        
    }
    
    func startPendulumAnimation() {
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            self.isLongPress = false
            self.rotationAngle = .degrees(10.0 * self.direction)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.direction *= -1
            if !self.isLongPress {
                self.startPendulumAnimation()
            }
        }
    }
    
    private func clampRotationAngle(_ angle: Angle) -> Angle {
            let clampedAngle = min(max(angle.degrees, -30.0), 30.0)
            return .degrees(clampedAngle)
        }
    
    func reset() {
        self.rotationAngle = .degrees(0.0)
        self.direction = 1.0
        self.dragOffset = .zero
        self.isLongPress = false
    }
}
