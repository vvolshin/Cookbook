//
//  MealsView.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/9/25.
//

import SwiftUI

struct MealsView: View {
    @StateObject var vm = MealsVM()
    @Binding var selectedMode: DisplayModeVariants
    @StateObject var mealsNavigation: TabNavigation
    
    @State private var selectedCategory: String = "All"
    @State var isSearchPressed: Bool = false
    @State var isSortedByFavorites: Bool = false
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    
    init(selectedMode: Binding<DisplayModeVariants>) {
        self._selectedMode = selectedMode
        _mealsNavigation = StateObject(wrappedValue: TabNavigation(
            selectedMode: selectedMode.wrappedValue,
            isRecipesEmpty: true,
            isSearching: false
        ))
    }
    
    var body: some View {
        NavigationStack {
            mainContent()
                .background(Color.ownYellow)
                .ignoresSafeArea(edges: .bottom)
                .modifier(ErrorAlertModifier(showAlert: $showAlert, errorMessage: vm.errorMessage))
        }
        .onAppear {
            vm.fetchMeals()
            vm.observeRecipesFromRealm(in: selectedCategory)
            vm.observeCategoriesFromRealm()
        }
        .onChange(of: selectedCategory) {
            isSortedByFavorites
            ? vm.observeFavoriteRecipesFromRealm(in: selectedCategory)
            : vm.observeRecipesFromRealm(in: selectedCategory)
        }
        .onChange(of: vm.meals) {
            mealsNavigation.updateScreen(isRecipesEmpty: vm.meals.isEmpty)
        }
        .onChange(of: selectedMode) {
            mealsNavigation.updateMode(selectedMode)
        }
        .onChange(of: isSearchPressed) {
            mealsNavigation.updateSearching(isSearchPressed)
        }
        .onChange(of: isSortedByFavorites) {
            isSortedByFavorites
            ? vm.observeFavoriteRecipesFromRealm(in: selectedCategory)
            : vm.observeRecipesFromRealm(in: selectedCategory)
            
            isSortedByFavorites
            ? vm.observeFavoriteCategoriesFromRealm() : vm.observeCategoriesFromRealm()
        }
    }
    
    private func mainContent() -> some View {
        ZStack {
            switch mealsNavigation.screen {
            case .showingInList:
                mealsListView()
            case .showingInGrid:
                mealsGridView()
            case .searching:
                searchView()
                    .transition(.blurReplace)
            case .showingPlaceholder:
                placeholderView()
            }
        }
    }
    
    private func mealsListView() -> some View {
        VStack {
            topBar()
            ItemsList(recipes: $vm.meals, recipeType: .meal, viewModelProvider: vm.viewModelForRecipe)
                .background(Color.ownWhite)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
    }
    
    private func mealsGridView() -> some View {
        VStack {
            topBar()
            ItemsGrid(recipes: $vm.meals, recipeType: .meal, viewModelProvider: vm.viewModelForRecipe)
                .background(Color.ownWhite)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
    }
    
    private func searchView() -> some View {
        SearchView(recipeType: .meal) {
            self.isSearchPressed.toggle()
        }
    }
    
    private func placeholderView() -> some View {
        VStack {
            topBar()
            Text("No meals available.")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.ownWhite)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
    }
    
    private func topBar() -> some View {
        VStack {
            HStack {
                SearchButton(isSearchPressed: $isSearchPressed)
                Spacer()
                if vm.isLoading {
                    ProgressView()
                        .padding(.horizontal, 8.0)
                        .tint(Color.black)
                }
                DisplayModeToggler(selection: $selectedMode)
            }
            
            HStack {
                Text("Meals")
                    .font(.system(size: 34))
                    .padding(.top, 3.0)
                    .padding(.bottom, 8.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                FavoriteToggler(isFavoriteOn: isSortedByFavorites, toggleAction: {
                    isSortedByFavorites.toggle()
                })
            }
            
            if vm.categories.count > 1 {
                CategoriesCarousel(
                    categories: $vm.categories,
                    selectedCategory: $selectedCategory
                )
            }
        }
        .padding(.horizontal, 16.0)
        .background(Color.ownYellow)
    }
}
