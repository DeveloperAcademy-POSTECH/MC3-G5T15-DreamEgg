//
//  HapticFeedbackTestView.swift
//  DreamEgg
//
//  Created by 차차 on 2023/07/13.
//

import SwiftUI

struct HapticFeedbackTestView: View {
    var body: some View {
        VStack(spacing: 20) {
            Group {
                Text("Notification type".uppercased())
                    .font(.title.bold())
                
                Button("warning") {
                    HapticManager.instance.notification(type: .warning)
                    
                }
                
                Button("error") {
                    HapticManager.instance.notification(type: .error)
                    
                }
                
                Button("success") {
                    HapticManager.instance.notification(type: .success)
                    
                }
            }
            
            
            Group {
                Text("impact style".uppercased())
                    .font(.title.bold())
                
                Button("heavy") {
                    HapticManager.instance.impact(style: .heavy)
                    
                }
                
                Button("light") {
                    HapticManager.instance.impact(style: .light)
                    
                }
                
                Button("medium") {
                    HapticManager.instance.impact(style: .medium)
                    
                }
                
                Button("rigid") {
                    HapticManager.instance.impact(style: .rigid)
                    
                }
                
                Button("soft") {
                    HapticManager.instance.impact(style: .soft)
                    
                }
            }
            
            Group {
                Text("selection Changed".uppercased())
                    .font(.title.bold())
                
                Button("selectionChanged") {
                    HapticManager.instance.selection()
                    
                }
            }
            
            Group {
                Text("AVFoundation".uppercased())
                    .font(.title.bold())
                
                Button("old school") {
                    HapticManager.instance.avFoundation()
                    
                }
            }
        }
    }
}

struct HapticFeedbackTestView_Previews: PreviewProvider {
    static var previews: some View {
        HapticFeedbackTestView()
    }
}
