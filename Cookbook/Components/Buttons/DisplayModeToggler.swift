import SwiftUI

enum DisplayModeVariants: Int {
    case list
    case grid
}

struct DisplayModeToggler: View {
    @Binding var selection: DisplayModeVariants
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { selection == .list },
            set: { newValue in
                selection = newValue ? .list : .grid
            }
        )) {}
            .toggleStyle(DisplayModeTogglerTogglerStyle())
    }
}

struct DisplayModeTogglerTogglerStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 80, height: 40)
                .foregroundColor(.ownWhite)
                .overlay(
                    Image(configuration.isOn ? "Grid" : "List")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                        .padding(configuration.isOn ? .leading : .trailing, 40)
                )
            
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.ownOrange)
                .shadow(color: .gray.opacity(0.7),
                        radius: 2,
                        x: configuration.isOn ? 1 : -1,
                        y: -1)
                .overlay(
                    Image(configuration.isOn ?
                          "List" : "Grid")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(.black)
                )
                .offset(x: configuration.isOn ? -20 : 20)
        }
        .frame(width: 80, height: 40)
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}

#Preview {
    ZStack {
        Color("ownYellow")
            .ignoresSafeArea()
        DisplayModeToggler(selection: .constant(.list))
    }
}
