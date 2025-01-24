//
//  BackButton.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 12/19/24.
//

import SwiftUI

struct BackButton: View {
    var onDismiss: () -> Void
    
    var body: some View {
        Button(action: {
            onDismiss()
        }) {
            Image("Arrow-left")
                .frame(width: 40, height: 40)
                .foregroundColor(Color.ownBlack)
        }
    }
}
