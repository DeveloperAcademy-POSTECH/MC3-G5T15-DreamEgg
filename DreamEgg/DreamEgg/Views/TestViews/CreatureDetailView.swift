//
//  CreatureDetailView.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/07/25.
//

import SwiftUI

struct CreatureDetailView: View {
    @State private var dreamPetName: String = "꼬까"
    @State private var animalName: String = "쿼카"
    @State private var birthDate = Date()
    @State private var incubateTime = Date()
    @State private var isFix: Bool = false
    
    /// birthDate.year를 하면 Int값 2,023이 나와서 타입 바꿨습니다
    var getStrYear: String {
        let year = String(birthDate.year)
        return year
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                HStack {
                    Text("Dream Pet Info")
                        .font(.dosIyagiBold(.largeTitle))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink {
                        LofiDreamWorldView()
                    } label: {
                        Image("DreamWorldIcon")
                    }
                    .overlay {
                        Image(isFix ? "" : "BadgeDot")
                            .position(x: 40, y: 10)
                    }
                }
                .padding()
                
                Image("Quakka_Face")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 300)
                    .background {
                        Circle()
                            .fill(Color.eggYellow)
                            .frame(maxWidth: 206, maxHeight: 206)
                    }
                    .background {
                        Circle()
                            .fill(Color.primaryButtonYellow)
                            .frame(maxWidth: 250, maxHeight: 250)
                    }
                
                Spacer()
                
                VStack {
                    HStack {
                        Text("이름")
                        
                        Spacer()
                        
                        Text(dreamPetName)
                            .foregroundColor(Color.secondary)
                        
                        Button {
                        } label: {
                            Image(systemName: "pencil.line")
                                .foregroundColor(Color.secondary)
                        }
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Text("분류")
                        
                        Spacer()
                        
                        Text("\(animalName)")
                            .foregroundColor(Color.secondary)
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Text("태어난 날")
                        
                        Spacer()
                        
                        Text("\(getStrYear)년 \(birthDate.month)월 \(birthDate.day)일")
                            .foregroundColor(Color.secondary)
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Text("품어진 시간")
                        
                        Spacer()
                        
                        Text("\(incubateTime.hour)시간 \(incubateTime.minute)분")
                            .foregroundColor(Color.secondary)
                    }
                    .padding(.vertical)
                }
                .font(.dosIyagiBold(.title3))
                .frame(width: 294, height: 204)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.subButtonSky)
                        .frame(width: 342, height: 258)
                }
                .padding()
                
                Spacer()
                
                /// UI toggle을 구현했습니다.
                Button {
                    isFix.toggle()
                } label: {
                    Text(isFix ? "드림월드에 고정하기" : "드림월드에서 고정 해제하기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(isFix ? .primaryButtonBrown : .subButtonBlue)
                        .font(.dosIyagiBold(.body))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFix ? Color.primaryButtonBrown : Color.subButtonBlue, lineWidth: 5)
                        }
                        .background {isFix ? Color.primaryButtonYellow : Color.subButtonSky}
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
    }
}

struct CreatureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CreatureDetailView()
    }
}
