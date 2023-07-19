//
//  EggInteractionTestView.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/13.
//

import SwiftUI

struct EggInteractionTestView: View {
    var body: some View {
        VStack {
//            Image("BinyEgg")
//                .resizable()
//                .frame(width: 300, height: 300)
            PendulumAnimation(imageName: "BinyEgg", amplitude: 10.0, animationDuration: 1.0)
                .frame(width: 300, height: 300)
        }
    }
}



struct EggInteractionTestView_Previews: PreviewProvider {
    static var previews: some View {
        EggInteractionTestView()
    }
}
