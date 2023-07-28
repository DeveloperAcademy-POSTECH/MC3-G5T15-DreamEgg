//
//  LofiCurtainView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiCurtainView: View {
    @State private var movedHorizontalDistance: CGFloat = .zero
    @State private var movedHorizontalOffset: CGFloat = .zero
    @State private var isCurtainDragComplete: Bool = false
    
    private var isCurtainDragged: Bool {
        (UIScreen.main.bounds.width / 4) * 2.75 < abs(movedHorizontalDistance)
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                
                Text(isCurtainDragComplete ? "품은 알에서 \n드림펫이 태어났어요!": "\n")
                    .font(.dosIyagiBold(.title))
                    .multilineTextAlignment(.center)
                    .frame(maxHeight: 200)
                
                if isCurtainDragComplete {
                    Image("Quakka_b")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 250, maxHeight: 250)
                } else {
                    Color.gray
                        .frame(maxWidth: 250, maxHeight: 250)
                        .mask {
                            Image("Quakka_b")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                }
                
                Spacer()
                
                if isCurtainDragComplete {
                    NavigationLink {
                        LofiCreatureNamingView()
                    } label: {
                        Text("이름을 지어주자")
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
                    .padding(.horizontal)
                    
                    NavigationLink {
                        LofiNameConfirmView(confirmedName: .constant(""))
                    } label: {
                        Text("건너뛰기")
                            .foregroundColor(.subButtonSky)
                            .font(.dosIyagiBold(.callout))
                    }
                    .padding(.vertical, 32)
                    .padding(.horizontal)
                }
            }
            .animation(.easeInOut(duration: 1.0), value: isCurtainDragComplete)
            
            Image("DECurtain")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(x: isCurtainDragComplete ? -(UIScreen.main.bounds.width) : self.movedHorizontalDistance)
                .colorMultiply(.gray)
                .gesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged({ value in
                            if value.translation.width < 0 {
                                self.movedHorizontalDistance = movedHorizontalOffset + value.translation.width
                            }
                            
                        })
                        .onEnded({ value in
                            if value.translation.width < 0 {
                                self.movedHorizontalOffset = movedHorizontalOffset + value.translation.width
                            }
                        })
                )
                .opacity(isCurtainDragComplete ? 0.0 : 1.0)
                .animation(.easeInOut(duration: 1.0), value: isCurtainDragComplete)
        }
        .ignoresSafeArea()
        .onChange(of: movedHorizontalDistance) { newValue in
            if isCurtainDragged {
                isCurtainDragComplete = true
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct LofiCurtainView_Previews: PreviewProvider {
    static var previews: some View {
        LofiCurtainView()
    }
}
