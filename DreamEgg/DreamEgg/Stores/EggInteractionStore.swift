//
//  EggInteractionStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/13.
//

import SwiftUI

//MARK: 달걀 그림 그리는 뷰
struct EggDrawGesture: View {
    @State var points: [CGPoint] = []
    @Binding var isDrawEgg: Bool
    
    let includeEllipsePath = Ellipse()
        .path(in: CGRect(x: UIScreen.main.bounds.width/2 - 280/2, y: UIScreen.main.bounds.height/2 - 360/2 - 40, width: 280, height: 360))
    let exceptEllipsePath = Ellipse()
        .path(in: CGRect(x: UIScreen.main.bounds.width/2 - 150/2, y: UIScreen.main.bounds.height/2 - 220/2 - 40, width: 160, height: 230))
    var body: some View {
        ZStack {
            Image("emptyEgg")
            DrawShape(points: points)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(.white)
                .opacity(0.7)    
        }
        .gesture(DragGesture().onChanged( { value in
            if isPointInsideEllipse(value.location) {
                self.addNewPoint(value)
                print("count: \(points.count)")
            }
        })
            .onEnded( { value in
                if points.count >= 30 {
                    isDrawEgg = true
                    print("success")
                }
                points = []
            }))
        
    }
    
    private func addNewPoint(_ value: DragGesture.Value) {
        points.append(value.location)
    }
    
    private func isPointInsideEllipse(_ point: CGPoint) -> Bool {
        return includeEllipsePath.contains(point) && !exceptEllipsePath.contains(point)
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

//MARK: 달걀 애니메이션 뷰
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
