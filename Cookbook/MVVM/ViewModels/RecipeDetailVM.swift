//
//  RecipeDetailVM.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/13/25.
//

import Foundation
import RxSwift

extension RecipeDetailView {
    final class RecipeDetailVM: ObservableObject, Identifiable {
        @Published var recipe: Recipe
        @Published var isFavorite: Bool
        @Published var errorMessage: String?
        
        internal let disposeBag = DisposeBag()
        internal var realmService: RealmServiceProtocol?
        
        init(recipe: Recipe, recipeType: RecipeType) {
            self.recipe = recipe
            self.isFavorite = recipe.isFavorite
            
            let serviceName: String
            switch recipeType {
            case .meal:
                serviceName = "meal"
            case .drink:
                serviceName = "drink"
            case .own:
                serviceName = "own"
            }

            self.realmService = Database.shared.container.resolve(RealmServiceProtocol.self, name: serviceName)
        }
    }
}
