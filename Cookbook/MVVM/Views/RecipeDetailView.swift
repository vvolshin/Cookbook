//
//  RecipeDetail.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/13/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var vm: RecipeDetailVM
    
    @Environment(\.dismiss) var dismiss
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            topBar()
            mainContent()
                .background(Color.ownWhite)
                .clipShape(.rect(cornerRadii: .init(topLeading: 25, topTrailing: 25)))
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.ownYellow)
        .navigationBarBackButtonHidden(true)
        .scrollIndicators(.hidden)
    }
    
    private func topBar() -> some View {
        HStack {
            BackButton() {
                dismiss()
            }
            Spacer()
        }
        .padding(.horizontal, 16.0)
    }
    
    private func mainContent() -> some View {
        ScrollView {
            headerArea(name: vm.recipe.name ?? "")
                .padding(.all, 16)
            
            RecipeImage(imageData: vm.recipe.thumbnail, width: 370, height: 339, cornerRadius: 25)
                .padding([.leading, .bottom, .trailing], 16)
            
            ingredientsArea(recipe: vm.recipe)
                .padding([.leading, .bottom, .trailing], 16)
            
            instructionsArea(instructions: vm.recipe.instructions ?? "")
                .padding(.horizontal, 16)
            
            Spacer(minLength: 100)
        }
    }
    
    private func headerArea(name: String) -> some View {
        HStack {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(name.count > 15 ? .system(size: 24) : .system(size: 34))
                .truncationMode(.tail)
            
            FavoriteToggler(isFavoriteOn: vm.isFavorite, toggleAction: vm.toggleFavorite)
        }
    }
    
    private func ingredientsArea(recipe: Recipe) -> some View {
        let ingredients = recipe.ingredients
            .compactMap { $0.isEmpty ? nil : $0 }
        let measures = recipe.measures
            .compactMap { $0.isEmpty ? nil : $0 }
        
        let itemHeight: CGFloat = 44
        let totalHeight = CGFloat(ingredients.count) * itemHeight
        
        return VStack {
            Text("Ingredients")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 24))
            
            List {
                ForEach(Array(ingredients.enumerated()), id: \.element) { index, ingredient in
                    HStack {
                        Text(ingredient)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(measures.indices.contains(index) ? measures[index] : "")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(minHeight: totalHeight)
            .listStyle(PlainListStyle())
        }
    }
    
    private func instructionsArea(instructions: String) -> some View {
        VStack {
            Text("Instructions")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 24))
                .padding(.bottom, 16)
            
            Text(instructions)
                .padding(.horizontal, 16)
        }
    }
}
