//
//  LofiMainEggView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/20.
//

import SwiftUI

struct LofiMainEggView: View {
    @State private var tabSelection: Int = 1
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            TabView(selection: $tabSelection) {
                DECalendarTestView()
                    .tag(0)
                    .tabItem {
                        Image("CalendarTabIcon")
                    }
                
                // MARK: Main Egg
                VStack {
                    Spacer()
                        .frame(maxHeight: 36)
                    
                    DETitleHeader(title: "Dream Egg")
                    
                    Spacer()
                        .frame(maxHeight: 36)
                    
                    VStack {
                        Text("잠들기까지\n1시간 19분\n남았어요.")
                            .font(.dosIyagiBold(.title))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(12)
                        
                        NavigationLink {
                            SleepTimeSettingView()
                        } label: {
                            Text("시간 및 알림 수정하기")
                                .font(.dosIyagiBold(.body))
                                .foregroundColor(.white)
                                .overlay {
                                    VStack {
                                        Divider()
                                            .frame(minHeight: 2)
                                            .overlay(Color.white)
                                            .offset(y: 12)
                                    }
                                }
                                .padding()
                        }

                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                        .frame(maxHeight: 80)
                    
                    NavigationLink {
                        LofiSleepGuideView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Ellipse()
                            .stroke(
                                Color.white,
                                style: StrokeStyle(
                                    lineWidth: 10,
                                    dash: [8],
                                    dashPhase: 6
                                )
                            )
                            .frame(maxWidth: 200, maxHeight: 270)
                            .overlay {
                                Text("탭해서 \n알그리기")
                                    .font(.dosIyagiBold(.body))
                                    .foregroundColor(.white)
                            }
                        
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .tag(1)
                .tabItem {
                    Image("DreamEggTabIcon")
                }
                
                LofiDreamWorldView()
                    .tag(2)
                    .tabItem {
                        Image("DreamWorldTabIcon")
                    }
            }
            .tabViewStyle(.page)
            
        }
        .navigationBarBackButtonHidden()
    }
}

struct LofiMainEggView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LofiMainEggView()
        }
    }
}
