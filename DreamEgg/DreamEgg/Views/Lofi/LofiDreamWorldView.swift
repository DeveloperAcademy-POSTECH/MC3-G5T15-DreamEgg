//
//  LofiDreamWorldView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiDreamWorldView: View {
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Image("DreamWorldMap")
                    .resizable()
                    .frame(
                        maxHeight: UIScreen.main.bounds.height * 0.75,
                        alignment: .bottom
                    )
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            .frame(
                maxHeight: .infinity,
                alignment: .bottom
            )
            
        }
        .navigationTitle("Dream World")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct LofiDreamWorldView_Previews: PreviewProvider {
    static var previews: some View {
        LofiDreamWorldView()
    }
}
