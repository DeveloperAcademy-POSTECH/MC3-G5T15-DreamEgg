//
//  MapViewStore.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/10.
//

import Foundation
import SwiftUI

final class MapViewStore : ObservableObject {
    let mapWidth = UIScreen.main.bounds.width * 0.8
    let mapHeight = UIScreen.main.bounds.height * 0.7
    let objSize : CGFloat = 50
    let timers = [Timer.publish(every: 3, on: .main, in: .common).autoconnect(), Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()]
    var num : Int = 0
    @ObservedObject var dailySleepTimeStore = DailySleepTimeStore()
    @Published var positions = [CGPoint]()
    @Published var names = [[String]]()
    
    init() {
        self.num = dailySleepTimeStore.dailySleepDict.count
        getNamesFromCoreData()
        GeneratePosRandomly()
    }
    
    /// CoreData에서 객체들의 데이터를 받아와 객체들의 이름을 저장합니다.
    func getNamesFromCoreData() {
        for element in dailySleepTimeStore.dailySleepDict {
            names.append([element.value.animalName ?? "" ,"_a"])
        }
    }
    
    
    /// 드림펫들의 초기 위치를 지도 크기 내에서 서로 겹치지 않게 랜덤하게 설정합니다.
    func GeneratePosRandomly() {
        let xPosBoundary = mapWidth - objSize * 2
        let yPosBoundary = mapHeight * 0.15 - objSize / 2
        var xPosTemp: CGFloat
        var yPosTemp: CGFloat
        var isDuplicated : Bool
        var j : Int

        for i in 0 ..< num {
            while true {
                isDuplicated = false
                j = 0
                xPosTemp = CGFloat(arc4random_uniform(UInt32(xPosBoundary))) + objSize
                yPosTemp = CGFloat(arc4random_uniform(UInt32(yPosBoundary))) + mapHeight * 0.85

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
    
    
    /// 드림펫들의 위치를 지도 크기 내에서 서로 겹치지 않도록 랜덤하게 변경합니다.
    func changePosition() {
        var newXPos: CGFloat
        var newYPos: CGFloat
        var isDuplicated : Bool
        var j : Int
        var n : Int
        
        for i in 0 ..< num {
            n = 0
            
            while true {
                isDuplicated = false
                j = 0
                newXPos = positions[i].x + CGFloat(arc4random_uniform(UInt32(100))) - 50
                newYPos = positions[i].y + CGFloat(arc4random_uniform(UInt32(100))) - 50

                // map boundary check
                if newXPos < objSize || newYPos < mapHeight * 0.85 || newXPos > mapWidth - objSize || newYPos > mapHeight - objSize / 2 {
                    n += 1
                    continue
                }
                
                // object duplication check
                while n < 100 && j < i {
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
    
    
    /// 이미지의 이름을 변경을 통해 드림펫들의 애니메이션을 구현합니다.
    func changeImage() {
        for i in 0 ..< num {
            if names[i][1] == "_a" {
                names[i][1] = "_b"
            }
            else {
                names[i][1] = "_a"
            }
        }
    }
}
