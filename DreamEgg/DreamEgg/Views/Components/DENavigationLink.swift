//
//  DENavigationLink.swift
//  DreamEgg
//
//  Created by Sebin Kwon on 2023/07/27.
//

import SwiftUI

enum DENavigationLinkStyle {
    case primaryNavigationLink(isDisabled: Bool)
    case subNavigationLink(isDisabled: Bool)
}

struct DENavigationLink: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DENavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        DENavigationLink()
    }
}
