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
    @Published private var isAnimationRunning = false
    
    private init() {}
    
    func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                if !self.isLongPress {
                    self.isLongPress = true
                }
                let dragAngle = Angle(radians: Double(value.translation.width) * 0.01)
                let newRotationAngle = Angle.degrees(10.0) + dragAngle
                self.rotationAngle = self.clampRotationAngle(newRotationAngle)
            }
            .onEnded { value in
                self.isLongPress = false
                self.direction = self.rotationAngle.degrees >= 0 ? -1 : 1
                if !self.isAnimationRunning {
                    self.startPendulumAnimation()
                }
            }
    }
    
    func startPendulumAnimation() {
        self.rotationAngle = .degrees(10.0 * self.direction)
        self.isAnimationRunning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.direction = self.rotationAngle.degrees >= 0 ? -1 : 1
            if !self.isLongPress && self.isAnimationRunning {
                self.rotationAngle = .degrees(10.0 * self.direction)
                self.startPendulumAnimation()
            } else {
                self.isAnimationRunning = false
            }
        }
    }
    
    private func clampRotationAngle(_ angle: Angle) -> Angle {
        let clampedAngle = min(max(angle.degrees, -30.0), 30.0)
        return .degrees(clampedAngle)
    }
    
    func reset() {
        rotationAngle = .degrees(0.0)
        direction = 1.0
        dragOffset = .zero
        isAnimationRunning = false
    }
}
