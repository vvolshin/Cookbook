//
//  DrinksVMExtension.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/24/25.
//

import Foundation
import Realm
import RxSwift

extension DrinksView.DrinksVM {
    func fetchDrinks() {
        CookbookAPI.fetchDrinks()
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .do(
                onSubscribe: { [weak self] in
                    DispatchQueue.main.async {
                        self?.isLoading = true
                    }
                },
                onDispose: { [weak self] in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                    }
                }
            )
            .subscribe(
                onNext: { newDrinks in
                    self.saveDrinksToRealm(recipes: newDrinks)
                },
                onError: { error in
                    self.errorMessage = "Failed to load drinks: \(error)"
                })
            .disposed(by: disposeBag)
    }
    
    private func saveDrinksToRealm(recipes: [Recipe]) {
        self.drinkRealmService?.create(recipes: recipes)
            .subscribe(
                onError: { error in
                    DispatchQueue.main.async {
                        self.errorMessage = "Error saving drinks to Realm: \(error)"
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func observeRecipesFromRealm(in category: String) {
        self.drinkRealmService?.observeRecipes(in: category)
            .subscribe(
                onNext: { [weak self] readRecipe in
                    DispatchQueue.main.async {
                        self?.drinks = readRecipe
                    }
                },
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error reading drinks from Realm: \(error)"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    func observeCategoriesFromRealm() {
        self.drinkRealmService?.observeCategories()
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
        self.drinkRealmService?.observeFavoriteCategories()
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
        self.drinkRealmService?.observeFavoriteRecipes(in: category)
            .subscribe(
                onNext: { [weak self] readRecipe in
                    DispatchQueue.main.async {
                        self?.drinks = readRecipe
                    }
                },
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error reading drinks from Realm: \(error)"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
