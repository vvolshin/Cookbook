import SwiftUI

struct SearchButton: View {
    @Binding var isSearchPressed: Bool
    
    var body: some View {
        Button(action: {
            isSearchPressed.toggle()
        }) {
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.ownBlack)
                    .frame(width: 25, height: 22)
                Text("Search")
                    .foregroundColor(.ownSecondary)
            }
            .frame(width: 97, height: 41)
            .padding(.trailing, 12.0)
            .background(.ownWhite)
            .cornerRadius(25)
        }
    }
}
