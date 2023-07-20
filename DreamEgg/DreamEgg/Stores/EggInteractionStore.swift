//
//  EggInteractionStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/13.
//

import SwiftUI

//MARK: 달걀 그림 그리는 제스처
struct EggDrawGesture: View {
    @State var points: [CGPoint] = []

    var body: some View {
        ZStack {
            Image("emptyEgg")
//            Ellipse()
//                .stroke(style: StrokeStyle(lineWidth: 70, lineCap: .round))
//                .foregroundColor(.green)
//                .frame(width: 200, height: 300)
//                .opacity(0.5)
            DrawShape(points: points)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(.white)
                .opacity(0.7)
        }
        .gesture(DragGesture().onChanged( { value in
            self.addNewPoint(value)
        })
            .onEnded( { value in
                points = []
            }))
        
    }
    
    private func addNewPoint(_ value: DragGesture.Value) {
        points.append(value.location)
    }
}

//MARK: 달걀 그림 선
struct DrawShape: Shape {
    var points: [CGPoint]

        func path(in rect: CGRect) -> Path {
            var path = Path()
            guard let firstPoint = points.first else { return path }

            path.move(to: firstPoint)
            for pointIndex in 1..<points.count {
                path.addLine(to: points[pointIndex])

            }
            return path
        }
}

//MARK: 달걀 애니메이션
struct PendulumAnimation: View {
    @State private var rotationAngle: Angle = .degrees(0.0)
    @State private var direction: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    @State private var isLongPress = false
    let imageName: String
    let amplitude: CGFloat
    let animationDuration: Double
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(rotationAngle, anchor: .bottom)
            .animation(Animation.easeInOut(duration: animationDuration), value: rotationAngle)
            .gesture(DragGesture()
                .onChanged { value in
                    isLongPress = true
                    let dragAngle = Angle(radians: Double(value.translation.width) * 0.01)
                    let newRotationAngle = Angle.degrees(amplitude * Double(direction)) + dragAngle
                                        rotationAngle = clampRotationAngle(newRotationAngle)
                }
                .onEnded { value in
                    rotationAngle = .degrees(0)
                    isLongPress = false
                    startPendulumAnimation()
                }
            )
            .onAppear {
                startPendulumAnimation()
            }
    }

    private func startPendulumAnimation() {
        withAnimation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
            isLongPress = false
            rotationAngle = .degrees(amplitude * direction)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            direction *= -1
            if !isLongPress {
                startPendulumAnimation()
            }
        }
    }
    
    private func clampRotationAngle(_ angle: Angle) -> Angle {
            let clampedAngle = min(max(angle.degrees, -30.0), 30.0)
            return .degrees(clampedAngle)
        }
}
