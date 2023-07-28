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
            ZStack(alignment: .bottom) {
                ForEach((0 ..< mapViewStore.num), id: \.self) { i in
                    Image("\(mapViewStore.names[i][0])"+"\(mapViewStore.names[i][1])")
                        .position(mapViewStore.positions[i])
                }
            }
        .onReceive(mapViewStore.timers[0]) { _ in
            withAnimation {
                mapViewStore.changePosition()
            }
        }
        .onReceive(mapViewStore.timers[1]) { _ in
            mapViewStore.changeImage()
        }
    }
}

struct LofiDreamWorldView_Previews: PreviewProvider {
    static var previews: some View {
        LofiDreamWorldView()
//        LofiMainTabView()
    }
}
