//
//  LofiDreamWorldView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiDreamWorldView: View {
    var body: some View {
        VStack {
            DETitleHeader(title: "Dream World")
            
            Spacer()
                .frame(maxHeight: 24)
            
            Image("DreamWorldMap")
                .resizable()
                .frame(
                    maxHeight: .infinity
                )
                .aspectRatio(contentMode: .fit)
                .padding()
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
