import SwiftUI

struct ContentView: View {
    @State private var selectedTab: RecipeType = .own
    @State private var selectedMode: DisplayModeVariants = .list
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.ownWhite.withAlphaComponent(0.9)
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().unselectedItemTintColor = .ownBlack
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Meals", systemImage: "fork.knife", value: RecipeType.meal) {
                MealsView(selectedMode: $selectedMode)
            }
            
            Tab("Own", systemImage: "book.closed.fill", value: RecipeType.own) {
                OwnView(selectedMode: $selectedMode)
            }
            
            Tab("Drinks", image: "Drinks", value: RecipeType.drink) {
                DrinksView(selectedMode: $selectedMode)
            }
        }
        .tint(.ownOrange)
    }
}

#Preview {
    ContentView()
}
