//
//  View+ActivateConfetti.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/25.
//

import SwiftUI

/** confetti에 애니메이션에 대한 설정 2 */
private struct ParticlesModifier: ViewModifier {
    @State private var time = 0.0
    @State private var scale = 0.07
    let duration = 3.0

    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<40, id: \.self) { index in
                content
//                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration - time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 0.7
            }
        }
    }
}

/** confetti 애니메이션에 대한 설정 1 */
private struct FireworkParticlesGeometryEffect: GeometryEffect {
    var time: Double
    var speed = Double.random(in: 50 ... 200)
    var direction = Double.random(in: -Double.pi ... Double.pi)

    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * (time / 2)
        let yTranslation = speed * sin(direction) * (time / 2)
        
        let affineTranslation = CGAffineTransform(
            translationX: xTranslation,
            y: yTranslation
        )
        return ProjectionTransform(affineTranslation)
    }
}


extension View {
    func activateConfetti() -> some View {
        modifier(ParticlesModifier())
    }
}
