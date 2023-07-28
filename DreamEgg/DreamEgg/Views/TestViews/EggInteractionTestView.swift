//
//  EggInteractionTestView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/13.
//

import SwiftUI

struct EggInteractionTestView: View {
    @State var points: [CGPoint] = []
    @StateObject private var eggDrawStore = EggDrawStore()
    @StateObject private var eggAnimation = EggAnimation()
    var body: some View {
        ZStack {
            GradientBackgroundView()
            if eggDrawStore.isDrawEgg {
                VStack {
                    Image("BinyEgg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .rotationEffect(eggAnimation.rotationAngle, anchor: .bottom)
                        .gesture(eggAnimation.dragGesture())
                        .animation(Animation.easeInOut(duration: 1.0), value: eggAnimation.rotationAngle)
                        .onAppear {
                            eggAnimation.startPendulumAnimation()
                        }
                    Button("reset") {
                        eggDrawStore.isDrawEgg = false
                        eggAnimation.reset()
                    }
                }
            } else {
                Image("emptyEgg")
                DrawShape(points: eggDrawStore.points)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(.white)
                    .opacity(0.7)
            }
            
        }
        .animation(eggDrawStore.isDrawEgg ? Animation.easeInOut : nil)
        .gesture(eggDrawStore.gesture())
    }
}



struct EggInteractionTestView_Previews: PreviewProvider {
    static var previews: some View {
        EggInteractionTestView()
    }
}
