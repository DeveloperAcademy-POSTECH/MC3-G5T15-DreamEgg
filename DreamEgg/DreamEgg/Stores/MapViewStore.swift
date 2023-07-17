//
//  MapViewStore.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/10.
//

import Foundation
import SwiftUI

class MapViewStore : ObservableObject {
    let mapWidth = UIScreen.main.bounds.width * 0.8
    let mapHeight = UIScreen.main.bounds.height * 0.7
    let objSize : CGFloat = 70
    let timers = [Timer.publish(every: 1.5, on: .main, in: .common).autoconnect(), Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()]
    var num  = 0
    @Published var positions = [CGPoint]()
    @Published var names = [[String]]()
    
    init() {
        self.num = getNumFromCoreData() // CoreData 구현 코드와 병합 후 구현 예정입니다.
        getNamesFromCoreData() // CoreData 구현 코드와 병합 후 구현 예정입니다.
        GeneratePosRandomly()
    }
    
    func getNumFromCoreData() -> Int { // CoreData에서 객체들의 데이터를 받아와, 객체들의 갯수를 저장합니다.
        return 5 // 시연을 위해 임의로 설정해두었습니다.
    }
    
    func getNamesFromCoreData() { // 코어 데이터에서 객체들의 데이터를 받아와, 객체들의 이름을 저장합니다.
        for _ in 0 ..< num { // 시연을 위해 임의로 객체들의 이름을 넣어두었습니다.
            names.append(["beenzino","BreathIn"])
        }
    }
    
    func GeneratePosRandomly() { // 객체들의 초기 위치를 지도 크기 내에서 객체들이 서로 겹치지 않게 랜덤하게 설정합니다.
        let xPosBoundary = mapWidth - objSize * 2
        let yPosBoundary = mapHeight - objSize * 2
        var xPosTemp: CGFloat
        var yPosTemp: CGFloat
        var isDuplicated : Bool
        var j : Int

        for i in 0 ..< num {
            while true {
                isDuplicated = false
                j = 0
                xPosTemp = CGFloat(arc4random_uniform(UInt32(xPosBoundary))) + objSize
                yPosTemp = CGFloat(arc4random_uniform(UInt32(yPosBoundary))) + objSize

                while j < i {
                    if pow(self.positions[j].x - xPosTemp, 2) + pow(self.positions[j].y - yPosTemp, 2) <= pow(objSize,2) {
                        isDuplicated = true
                        break
                    }
                    j += 1
                }

                if isDuplicated == false {
                    self.positions.append(CGPoint(x: xPosTemp, y: yPosTemp))
                    break
                }
            }
        }
    }
    
    func changePosition() { // 객체들의 위치를 랜덤하게 변경합니다. 변경 시에도 지도 크기내에서 객체들이 서로 겹치지 않게 변경합니다.
        var newXPos: CGFloat
        var newYPos: CGFloat
        var isDuplicated : Bool
        var j : Int

        for i in 0 ..< num {
            while true {
                isDuplicated = false
                j = 0
                newXPos = positions[i].x + CGFloat(arc4random_uniform(UInt32(100))) - 50
                newYPos = positions[i].y + CGFloat(arc4random_uniform(UInt32(100))) - 50

                // map boundary check
                if newXPos < objSize / 2 || newYPos < objSize / 2 || newXPos > mapWidth - objSize / 2 || newYPos > mapHeight - objSize / 2 {
                    continue
                }
                
                // object duplication check
                while j < i {
                    if pow(newXPos - positions[j].x , 2) + pow(newYPos - positions[j].y , 2) <= pow(objSize,2) {
                        isDuplicated = true
                        break
                    }
                    j += 1
                }

                if isDuplicated == false {
                    positions[i].x = newXPos
                    positions[i].y = newYPos
                    break
                }
            }
        }
    }
    
    func changeImage() { // 호흡 애니메이션 구현을 위해 이미지의 이름을 변경합니다.
        for i in 0 ..< num {
            if names[i][1] == "BreathIn" {
                names[i][1] = "BreathOut"
            }
            else {
                names[i][1] = "BreathIn"
            }
        }
    }
}