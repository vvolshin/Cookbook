//
//  ItemOfList.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

import SwiftUI

extension ItemsList {
    struct ItemOfList: View {
        @ObservedObject var vm: RecipeDetailView.RecipeDetailVM
        var width: CGFloat
        var height: CGFloat
        var cornerRadius: CGFloat
        
        var body: some View {
            HStack {
                RecipeImage(imageData: vm.recipe.thumbnail, width: width, height: height, cornerRadius: cornerRadius)
                
                recipeNameArea(name: vm.recipe.name ?? "Unknown")
                
                Spacer()
                
                FavoriteToggler(isFavoriteOn: vm.isFavorite, toggleAction: vm.toggleFavorite)
                    .padding(.trailing, 16)
                
            }
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.ownSecondary, lineWidth: 0.5)
            )
        }
        
        private func recipeNameArea(name: String) -> some View {
            Text(name)
                .font(name.count > 30 ? .system(size: 14) : .system(size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(.leading, 16)
        }
    }
}
