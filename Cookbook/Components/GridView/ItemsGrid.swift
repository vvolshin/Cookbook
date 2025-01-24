import SwiftUI

struct ItemsGrid: View {
    @Binding var recipes: [Recipe]
    var recipeType: RecipeType
    var viewModelProvider: (Recipe, RecipeType) -> RecipeDetailView.RecipeDetailVM

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                    ForEach(recipes, id: \.id) { recipe in
                        let recipeVM = viewModelProvider(recipe, recipeType)
                        NavigationLink(destination: {
                            RecipeDetailView(vm: recipeVM)
                        }) {
                            ItemOfGrid(vm: recipeVM, width: 177, height: 215, cornerRadius: 16)
                        }
                    }
                }
            }
            .padding(.all, 16.0)
        }
    }
}

