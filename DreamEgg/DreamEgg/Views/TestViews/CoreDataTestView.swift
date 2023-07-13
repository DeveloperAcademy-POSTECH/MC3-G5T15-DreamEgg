//
//  CoreDataTestView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/10.
//

import SwiftUI

struct CoreDataTestView: View {
    @ObservedObject private var dailySleepTimeStore = DailySleepTimeStore(
        coreDataStore: .debugShared
    )
    
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
                
                Button {
                    dailySleepTimeStore.updateAndSave(
                        with: DailySleepInfo(
                            id: .init(),
                            animalName: animalName,
                            date: date,
                            sleepTime: sleepTime
                        )
                    )
                } label: {
                    Text("Sleep Data 저장")
                }
                
                ForEach(dailySleepTimeStore.dailySleepArr) { dailySleepInfo in
                    NavigationLink(value: dailySleepInfo) {
                        Text("\(dailySleepInfo.date?.formatted() ?? "") 날짜 보러가기")
                    }
                }
                .navigationDestination(for: DailySleep.self) { dailySleepInfo in
                    Text("그 날짜의 동물은 \(dailySleepInfo.animalName ?? "")")
                }
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
