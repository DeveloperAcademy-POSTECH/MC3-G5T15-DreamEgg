//
//  LofiDreamWorldView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiDreamWorldView: View {
    @ObservedObject var mapViewStore = MapViewStore()


    var body: some View {
        VStack {
            DETitleHeader(title: "Dream World")

            Spacer()
                .frame(maxHeight: 24)

            ZStack {
                Image("DreamWorldMap")
                    .resizable()
                    .frame(
                        width: mapViewStore.mapWidth,
                        height: mapViewStore.mapHeight
                    )
                    .aspectRatio(contentMode: .fit)
                    .padding()

                ForEach((0...mapViewStore.num - 1), id: \.self) { i in
                    Button(action:{

                    }) {
                        Image("\(mapViewStore.names[i][0])"+"\(mapViewStore.names[i][1])")
                    }
                    .position(mapViewStore.positions[i])
                }
            }
            .frame(width: mapViewStore.mapWidth, height: mapViewStore.mapHeight)
            .onReceive(mapViewStore.timers[0]) { _ in
                withAnimation {
                    mapViewStore.changePosition()
                }
            }
            .onReceive(mapViewStore.timers[1]) { _ in
                mapViewStore.changeImage()
            }
        }
        .frame(
            maxHeight: .infinity
        )
        .padding(.bottom, 12)
    }
}

struct LofiDreamWorldView_Previews: PreviewProvider {
    static var previews: some View {
//        LofiDreamWorldView()
        LofiMainTabView()
    }
}
