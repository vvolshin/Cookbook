import SwiftUI

struct ItemsList: View {
    @Binding var recipes: [Recipe]
    var recipeType: RecipeType
    var viewModelProvider: (Recipe, RecipeType) -> RecipeDetailView.RecipeDetailVM

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(recipes, id: \.id) { recipe in
                    let recipeVM = viewModelProvider(recipe, recipeType)
                    NavigationLink(destination: {
                        RecipeDetailView(vm: recipeVM)
                    }) {
                        ItemOfList(vm: recipeVM, width: 105, height: 100, cornerRadius: 16)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding([.top, .horizontal], 16.0)
    }
}

