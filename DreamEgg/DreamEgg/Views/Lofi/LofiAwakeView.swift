//
//  LofiAwakeView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/19.
//

import SwiftUI

struct LofiAwakeView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Text("지금 몇신지나 아냐 이자식아")
                
                Text("얼만큼 잤는지 이것좀 봐라")
                
                Text("화면을 잠그면 더 잘수 있음")
                
            }
            .foregroundColor(.white)
        }
    }
}

struct LofiAwakeView_Previews: PreviewProvider {
    static var previews: some View {
        LofiAwakeView()
    }
}
