//
//  MapTestView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/12.
//

import SwiftUI

struct MapTestView: View {
    @ObservedObject var mapViewStore = MapViewStore()

    var body: some View {
        ZStack {
            ForEach((0...mapViewStore.num - 1), id: \.self) { i in
                Button(action:{
                    
                }) {
                    Image("\(mapViewStore.names[i][0])"+"\(mapViewStore.names[i][1])")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .position(mapViewStore.positions[i])
            }
        }
        .background(Color.green)
        .frame(width: mapViewStore.mapWidth, height: mapViewStore.mapHeight)
        .onReceive(mapViewStore.timers[0]) { _ in           // 객체들의 위치를 랜덤으로 변경합니다.
            withAnimation {
                mapViewStore.changePosition()
            }
        }
        .onReceive(mapViewStore.timers[1]) { _ in           // 객체들의 이미지를 변경합니다.
            mapViewStore.changeImage()
        }
    }
}

struct MapTestView_Previews: PreviewProvider {
    static var previews: some View {
        MapTestView()
    }
}
