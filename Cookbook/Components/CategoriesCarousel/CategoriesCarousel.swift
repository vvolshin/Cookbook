import SwiftUI

struct CategoriesCarousel: View {
    @Binding var categories: [String: Int]
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories.keys.sorted(), id: \.self) { category in
                    CarouselButton(name: category,
                                   count: categories[category] ?? 0,
                                   selectedCategory: $selectedCategory)
                }
            }
        }
    }
}
