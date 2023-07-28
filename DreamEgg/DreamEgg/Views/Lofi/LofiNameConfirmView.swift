//
//  LofiNameConfirmView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiNameConfirmView: View {
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    @EnvironmentObject var navigationManager: DENavigationManager
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                
                Text("\(dailySleepTimeStore.currentDailySleep?.animalName ?? "복실이")(가)\n드림월드로\n뛰어들어갔다!")
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack {
                    Button {
                        dailySleepTimeStore.completeDailySleepTime()
                        navigationManager.viewCycle = .general
                    } label: {
                        Text("드림월드 둘러보기")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.primaryButtonBrown)
                            .font(.dosIyagiBold(.body))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primaryButtonBrown, lineWidth: 5)
                            }
                    }
                    .background { Color.primaryButtonYellow }
                    .cornerRadius(8)
                    .padding()
                }
                .frame(
                    maxHeight: .infinity,
                    alignment: .bottom
                )
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct LofiNameConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        LofiNameConfirmView()
    }
}
