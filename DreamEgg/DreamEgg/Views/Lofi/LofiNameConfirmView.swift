//
//  LofiNameConfirmView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiNameConfirmView: View {
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                
//                Text("토순이(가)\n드림월드로\n뛰어들어갔다!")
                Text("Sammy has run into Dream World!")
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack {
                    NavigationLink {
                        ZStack {
                            GradientBackgroundView()
                            
                            LofiDreamWorldView()
                        }
                    } label: {
//                        Text("드림월드 둘러보기")
                        Text("Explore the Dream World")
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
