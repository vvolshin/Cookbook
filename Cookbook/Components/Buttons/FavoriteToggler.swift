//
//  FavoriteButton.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 12/19/24.
//

import SwiftUI

struct FavoriteToggler: View {
    let isFavoriteOn: Bool
    let toggleAction: () -> Void

    var body: some View {
        Button(action: toggleAction) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.black.opacity(0.25))
                Image("Heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 24.27)
                    .foregroundStyle(isFavoriteOn ? .ownDarkOrange : .ownBGGray)
            }
        }
        .frame(maxWidth: 40, alignment: .trailing)
        .animation(.default, value: isFavoriteOn)
    }
}
