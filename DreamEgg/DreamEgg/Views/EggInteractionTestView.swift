//
//  EggInteractionTestView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/13.
//

import SwiftUI

struct EggInteractionTestView: View {
    @State var points: [CGPoint] = []
    @State var isDrawEgg = false
    var body: some View {
        ZStack {
            GradientBackgroundView()
            if isDrawEgg {
                PendulumAnimation(imageName: "BinyEgg", amplitude: 10.0, animationDuration: 1.0)
                    .frame(width: 300, height: 300)
                Button("reset") {
                    isDrawEgg = false
                }
            } else {
                EggDrawGesture(isDrawEgg: $isDrawEgg)
                
            }
        }
    }
}



struct EggInteractionTestView_Previews: PreviewProvider {
    static var previews: some View {
        EggInteractionTestView()
    }
}
