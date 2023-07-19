//
//  FontTestView.swift
//  DreamEgg
//
//  Created by Celan on 2023/07/14.
//

import SwiftUI

struct FontTestView: View {
    var body: some View {
        VStack {
            Text("Dream Egg_Title")
                .font(.dosIyagiBold(.title))
            
            Text("Dream Egg_callout")
                .font(.dosIyagiBold(.callout))
            
            Text("Dream Egg_Caption")
                .font(.dosIyagiBold(.caption))
        }
    }
}

struct FontTestView_Previews: PreviewProvider {
    static var previews: some View {
        FontTestView()
    }
}
