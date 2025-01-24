//
//  OwnVMExtentsion.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/24/25.
//

import Foundation
import Realm
import RxSwift

extension OwnView.OwnVM {
    private func saveRecipeToRealm(recipes: [Recipe]) {
        self.ownRealmService?.create(recipes: recipes)
            .subscribe(
                onError: { error in
                    DispatchQueue.main.async {
                        self.errorMessage = "Error saving recipe to Realm: \(error)"
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func observeRecipesFromRealm(in category: String) {
        self.ownRealmService?.observeRecipes(in: category)
            .subscribe(
                onNext: { [weak self] readRecipe in
                    DispatchQueue.main.async {
                        self?.recipes = readRecipe
                    }
                },
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error reading recipes from Realm: \(error)"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    func observeCategoriesFromRealm() {
        self.ownRealmService?.observeCategories()
            .subscribe(
                onNext: { [weak self] realmCategory in
                    DispatchQueue.main.async {
                        self?.categories = realmCategory
                    }
                },
                onError: { error in
                    DispatchQueue.main.async {
                        self.errorMessage = "Error reading categories from Realm: \(error)"
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func observeFavoriteCategoriesFromRealm() {
        self.ownRealmService?.observeFavoriteCategories()
            .subscribe(
                onNext: { [weak self] realmCategory in
                    DispatchQueue.main.async {
                        self?.categories = realmCategory
                    }
                },
                onError: { error in
                    DispatchQueue.main.async {
                        self.errorMessage = "Error reading categories from Realm: \(error)"
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func observeFavoriteRecipesFromRealm(in category: String) {
        self.ownRealmService?.observeFavoriteRecipes(in: category)
            .subscribe(
                onNext: { [weak self] readRecipe in
                    DispatchQueue.main.async {
                        self?.recipes = readRecipe
                    }
                },
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error reading recipes from Realm: \(error)"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
