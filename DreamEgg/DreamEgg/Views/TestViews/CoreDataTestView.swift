//
//  CoreDataTestView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import SwiftUI

struct CoreDataTestView: View {
    @EnvironmentObject private var dailySleepTimeStore: DailySleepTimeStore
    
    @State private var animalName: String = ""
    @State private var sleepTime: String = ""
    @State private var date: Date = .now
    @State private var eachAnimal: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text("CoreData+DailySleepTime")
            }
            
            ScrollView {
                TextField("동물", text: $animalName)
                DatePicker("", selection: $date)
                TextField("수면시간", text: $sleepTime)
                    .keyboardType(.numberPad)
                
                Button {
                    dailySleepTimeStore.updateAndSaveNewDailySleepInfo()
                } label: {
                    Text("Sleep Data 저장")
                }
                
                ForEach(dailySleepTimeStore.dailySleepArray) { dailySleepInfo in
                    NavigationLink(value: dailySleepInfo) {
                        Text("\(dailySleepInfo.date?.formatted() ?? "") 날짜 보러가기")
                    }
                }
                .navigationDestination(for: DailySleep.self) { dailySleep in
                    UpdateView(
                        dailySleepManager: dailySleepTimeStore,
                        dailySleepInfo: dailySleep
                    )
                }
            }
        }
    }
}

struct UpdateView: View {
    @ObservedObject var dailySleepManager: DailySleepTimeStore
    @State var dailySleepInfo: DailySleep
    
    var body: some View {
        VStack {
            Text("그 날짜의 동물은 \(dailySleepInfo.animalName ?? "")")
            
            Button {
                dailySleepManager.updateAndSaveNewDailySleepInfo()
            } label: {
                Text("바꿔보기")
            }
        }
    }
}

struct CoreDataTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CoreDataTestView()
        }
    }
}
