//
//  EggDrawStore.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/21.
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

//MARK: 달걀 그리는 선
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
