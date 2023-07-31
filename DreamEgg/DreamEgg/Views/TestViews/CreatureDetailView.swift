//
//  CreatureDetailView.swift
//  DreamEgg
//
//  Created by apple_grace_goeun on 2023/07/25.
//

import SwiftUI

struct CreatureDetailView: View {
    @EnvironmentObject var dailySleepTimeStore: DailySleepTimeStore
    
    @State private var dreamPetName: String = ""
    @State private var animalSpecies: String = ""
    @State private var birthDate = Date()
    @State private var incubateTime: Int = 0
    
    @State private var isFixedDreamWorld: Bool = false
    @State private var isEditedName: Bool = false
    
    private let maxLength: Int = 10
    
    /// birthDate.year를 하면 Int값 2,023이 나와서 타입 바꿨습니다
    private var getStrYear: String {
        let year = String(birthDate.year)
        return year
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                DETitleHeader(title: "Dream Pet Info")
                
                Image("\(animalSpecies)_Face")
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
                    .offset(y: -10)
                
                Spacer()
                
                VStack {
                    HStack {
                        Text("이름")
                            .foregroundColor(.black)
                        
                        Spacer()
                        /// 이름값과 아이콘입니다.
                        HStack {
                            if isEditedName == false {
                                Text(dreamPetName)
                                    .foregroundColor(.black)
                                
                            } else if isEditedName == true {
                                TextField("\(dreamPetName)", text: $dreamPetName)
                                    .onChange(of: dreamPetName) { newValue in
                                        if dreamPetName.count > maxLength {
                                            dreamPetName = String(dreamPetName.prefix(maxLength))
                                        }
                                    }
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.black)
                            }
                            
                            /// true, false에 따라 수정 버튼이 바뀝니다.
                            Button {
                                if isEditedName {
                                    isEditedName.toggle()
                                    print("Editing Name", dreamPetName)
                                    dailySleepTimeStore.updateDreamPetName(
                                        by: dreamPetName,
                                        isSelected: true
                                    )
                                    
                                    if let dreampetName = dailySleepTimeStore.selectedDailySleep?.animalName {
                                        self.dreamPetName = dreampetName
                                    }
                                } else {
                                    isEditedName.toggle()
                                }
                            } label: {
                                isEditedName
                                ? Image(systemName: "checkmark")
                                    .foregroundColor(Color.subButtonBlue)
                                    .imageScale(.large)
                                : Image(systemName: "pencil.line")
                                    .foregroundColor(.black.opacity(0.6))
                                    .imageScale(.large)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
                        Text("분류")
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("\(animalSpecies)")
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
                        Text("태어난 날")
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("\(getStrYear)년 \(birthDate.month)월 \(birthDate.day)일")
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
                        Text("품어진 시간")
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("\(incubateTime / 60)시간 \(incubateTime % 60)분")
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding(.vertical, 20)
                }
                .font(.dosIyagiBold(.title3))
                .frame(width: 294, height: 204)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.subButtonSky)
                        .frame(width: 342, height: 290)
                }
                .padding()
                
                Spacer()
                
                /// UI toggle을 구현했습니다.
                Button {
                    isFixedDreamWorld.toggle()
                } label: {
                    Text(isFixedDreamWorld ? "드림월드에 고정하기" : "드림월드에서 고정 해제하기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(isFixedDreamWorld ? .primaryButtonBrown : .subButtonBlue)
                        .font(.dosIyagiBold(.body))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFixedDreamWorld ? Color.primaryButtonBrown : Color.subButtonBlue, lineWidth: 5)
                        }
                        .background {isFixedDreamWorld ? Color.primaryButtonYellow : Color.subButtonSky}
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            self.animalSpecies = dailySleepTimeStore.getAssetNameSafely(isSelected: true)
            self.dreamPetName = dailySleepTimeStore.getAnimalNameSafely(isSelected: true)
            self.birthDate = dailySleepTimeStore.getDreampetBirthdaySafely(isSelected: true)
            self.incubateTime = dailySleepTimeStore.getDreampetIncubateTimeSafely(isSelected: true)
            print(animalSpecies, dreamPetName, birthDate, incubateTime)
        }
        .onTapGesture {
            self.endTextEditing()
        }
    }
}

struct CreatureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CreatureDetailView()
    }
}
