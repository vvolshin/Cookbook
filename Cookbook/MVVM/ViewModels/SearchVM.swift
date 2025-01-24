//
//  SearchVM.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/19/25.
//

import Foundation
import RxSwift

extension SearchView {
    final class SearchVM: ObservableObject, RecipeProviderProtocol {
        @Published var searchedRecipes: [Recipe] = []
        @Published var errorMessage: String?
        
        internal let disposeBag = DisposeBag()
        internal var realmService: RealmServiceProtocol?
        
        init(recipeType: RecipeType) {
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

