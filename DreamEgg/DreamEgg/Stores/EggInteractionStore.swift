//
//  EggInteractionStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/13.
//

import SwiftUI

//MARK: 달걀 그림 그리기
class EggDrawStore: ObservableObject {
    @Published var points: [CGPoint] = []
    @Published var isDrawEgg = false
    
    let includeEllipsePath = Ellipse()
        .path(in: CGRect(x: UIScreen.main.bounds.width/2 - 280/2, y: UIScreen.main.bounds.height/2 - 360/2 - 40, width: 280, height: 360))
    let exceptEllipsePath = Ellipse()
        .path(in: CGRect(x: UIScreen.main.bounds.width/2 - 150/2, y: UIScreen.main.bounds.height/2 - 220/2 - 40, width: 160, height: 230))
    
    func gesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                if self.isPointInsideEllipse(value.location) {
                    self.addNewPoint(value)
                }
            }
            .onEnded { value in
                if self.points.count >= 30 {
                    self.isDrawEgg = true
                }
                self.points = []
            }
    }
    
    func addNewPoint(_ value: DragGesture.Value) {
        points.append(value.location)
    }
    
    func isPointInsideEllipse(_ point: CGPoint) -> Bool {
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

//MARK: 달걀 애니메이션
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
            .animation(Animation.easeInOut(duration: 1.0), value: rotationAngle)
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
//struct EggDrawGesturek: View {
//    @State var points: [CGPoint] = []
//    @Binding var isDrawEgg: Bool
//
//    let includeEllipsePath = Ellipse()
//        .path(in: CGRect(x: UIScreen.main.bounds.width/2 - 280/2, y: UIScreen.main.bounds.height/2 - 360/2 - 40, width: 280, height: 360))
//    let exceptEllipsePath = Ellipse()
//        .path(in: CGRect(x: UIScreen.main.bounds.width/2 - 150/2, y: UIScreen.main.bounds.height/2 - 220/2 - 40, width: 160, height: 230))
//    var body: some View {
//        ZStack {
//            Image("emptyEgg")
//            DrawShape(points: points)
//                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                .foregroundColor(.white)
//                .opacity(0.7)
//        }
//        .gesture(DragGesture().onChanged( { value in
//            if isPointInsideEllipse(value.location) {
//                self.addNewPoint(value)
//            }
//        })
//            .onEnded( { value in
//                if points.count >= 30 {
//                    isDrawEgg = true
//                }
//                points = []
//            }))
//
//    }
//
//    private func addNewPoint(_ value: DragGesture.Value) {
//        points.append(value.location)
//    }
//
//    private func isPointInsideEllipse(_ point: CGPoint) -> Bool {
//        return includeEllipsePath.contains(point) && !exceptEllipsePath.contains(point)
//    }
//}
