//
//  ItemOfGrid.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

import SwiftUI

extension ItemsGrid {
    struct ItemOfGrid: View {
        @ObservedObject var vm: RecipeDetailView.RecipeDetailVM
        var width: CGFloat
        var height: CGFloat
        var cornerRadius: CGFloat
        
        var body: some View {
            ZStack {
                RecipeImage(imageData: vm.recipe.thumbnail, width: width, height: height, cornerRadius: cornerRadius)
                
                VStack {
                    HStack {
                        Spacer()
                        FavoriteToggler(isFavoriteOn: vm.isFavorite, toggleAction: vm.toggleFavorite)
                    }
                    .padding(.all, 8.0)
                    
                    Spacer()
                    
                    HStack {
                        Text(vm.recipe.name ?? "")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.ownWhite)
                            .padding(.all, 16.0)
                        Spacer()
                    }
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.7),
                                Color.black.opacity(0.5),
                                Color.black.opacity(0.2),
                                Color.black.opacity(0)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
            }
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
