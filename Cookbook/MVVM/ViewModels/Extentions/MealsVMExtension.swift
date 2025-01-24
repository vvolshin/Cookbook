//
//  MealsVMExtension.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/24/25.
//

import Foundation
import RxSwift

extension MealsView.MealsVM {
    func fetchMeals() {
        CookbookAPI.fetchMeals()
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
                onNext: { newMeals in
                    self.saveMealsToRealm(recipes: newMeals)
                },
                onError: { error in
                    self.errorMessage = "Failed to load meals: \(error)"
                })
            .disposed(by: disposeBag)
    }
    
    private func saveMealsToRealm(recipes: [Recipe]) {
        self.mealRealmService?.create(recipes: recipes)
            .subscribe(
                onError: { error in
                    DispatchQueue.main.async {
                        self.errorMessage = "Error saving meals to Realm: \(error)"
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func observeRecipesFromRealm(in category: String) {
        self.mealRealmService?.observeRecipes(in: category)
            .subscribe(
                onNext: { [weak self] readRecipe in
                    DispatchQueue.main.async {
                        self?.meals = readRecipe
                    }
                },
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error reading meals from Realm: \(error)"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    func observeCategoriesFromRealm() {
        self.mealRealmService?.observeCategories()
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
        self.mealRealmService?.observeFavoriteCategories()
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
        self.mealRealmService?.observeFavoriteRecipes(in: category)
            .subscribe(
                onNext: { [weak self] readRecipe in
                    DispatchQueue.main.async {
                        self?.meals = readRecipe
                    }
                },
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error reading meals from Realm: \(error)"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
