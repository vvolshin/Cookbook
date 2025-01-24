//
//  TabNavigation.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/19/25.
//

import SwiftUI

final class TabNavigation: ObservableObject {
    enum Screen {
        case showingInList
        case showingInGrid
        case searching
        case showingPlaceholder
    }
    
    @Published private(set) var screen: Screen
    @Published var selectedMode: DisplayModeVariants
    @Published var isRecipesEmpty: Bool = true
    @Published var isSearching: Bool = false
    
    init(selectedMode: DisplayModeVariants, isRecipesEmpty: Bool, isSearching: Bool) {
        self.selectedMode = selectedMode
        self.isRecipesEmpty = isRecipesEmpty
        self.isSearching = isSearching
        
        self.screen = isRecipesEmpty ? .showingPlaceholder : (selectedMode == .list ? .showingInList : .showingInGrid)
    }
    
    func open(_ screen: Screen) {
        self.screen = screen
    }
    
    func updateScreen(isRecipesEmpty: Bool) {
        self.screen = isRecipesEmpty ? .showingPlaceholder : (selectedMode == .list ? .showingInList : .showingInGrid)
    }
    
    func updateMode(_ mode: DisplayModeVariants) {
        self.selectedMode = mode
        self.screen = selectedMode == .list ? .showingInList : .showingInGrid
    }
    
    func updateSearching(_ isSearching: Bool) {
        self.isSearching.toggle()
        withAnimation {
            self.screen = self.isSearching ? .searching : (selectedMode == .list ? .showingInList : .showingInGrid)
        }
    }
}
