//
//  DETitleHeader.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/21.
//

import SwiftUI

struct DETitleHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Spacer()
            
            DEFontStyle(style: .title2, text: "-<( \(title) )>-")
                .bold()
//            Text("-<( \(title) )>-")
//                .font(.dosIyagiBold(.title2))
//                .bold()
            
            Spacer()
        }
    }
}

struct DETitleHeader_Previews: PreviewProvider {
    static var previews: some View {
        DETitleHeader(title: "제목임")
    }
}
