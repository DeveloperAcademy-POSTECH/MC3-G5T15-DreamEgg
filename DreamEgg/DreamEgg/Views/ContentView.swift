//
//  ContentView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    enum DEViewCycle: String {
        case splash
        case starter
        case general
    }
    
    @State private var viewCycle: DEViewCycle = .splash
    
    var body: some View {
        switch viewCycle {
        case .splash:
            splashMock
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            // MARK: 추후 조건분기 필요
                            viewCycle = .starter
                        }
                    }
                }
            
        case .starter:
            SleepTimeSettingView()
                .frame(maxWidth: .infinity)
            
        case .general:
            NavigationStack {
                MainEggsView(countDown: 5)
            }
        }
    }
    
    private var splashMock: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Spacer()
                
                Image("DreamEggIcon")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                
                Text("Dream Egg")
                    .font(.dosPilgi(.title))
                    .foregroundColor(.primary)
                    .colorInvert()
                
                Spacer()
                
                Text("Copyright 2023 K-Jammy All rights reserved.")
                    .font(.dosIyagiBold(.caption))
                    .foregroundColor(.primary)
                    .colorInvert()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
