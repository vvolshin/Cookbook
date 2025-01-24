//
//  SearchView.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/16/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm: SearchVM
    var recipeType: RecipeType
    @State var searchQuery: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var onDismiss: () -> Void
    
    init(recipeType: RecipeType, onDismiss: @escaping () -> Void) {
        self.recipeType = recipeType
        self._vm = StateObject(wrappedValue: SearchVM(recipeType: recipeType))
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack {
            topBar()
            TextField("Enter query", text: $searchQuery)
                .focused($isTextFieldFocused)
                .keyboardType(.alphabet)
                .padding()
                .background(Color.ownWhite)
                .cornerRadius(8)
                .shadow(radius: 10)
                .padding(.horizontal)
            
            Spacer()
            
            ItemsList(recipes: $vm.searchedRecipes, recipeType: recipeType, viewModelProvider: vm.viewModelForRecipe)
                .background(Color.ownWhite)
                .clipShape(.rect(cornerRadii: .init(topLeading: 25, topTrailing: 25)))
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.ownYellow)
        .onAppear() {
            isTextFieldFocused = true
        }
        .onChange(of: searchQuery) {
            vm.searchRecipesInRealm(by: searchQuery)
        }
    }
    
    private func topBar() -> some View {
        ZStack {
            HStack {
                BackButton(onDismiss: {
                    onDismiss()
                })
                Spacer()
            }
            Text("Search")
                .font(.headline)
        }
        .padding(.horizontal, 16.0)
    }
}
