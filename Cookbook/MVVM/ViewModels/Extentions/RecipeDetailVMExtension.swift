//
//  RecipeDetailVMExtension.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/24/25.
//

import Foundation
import RxSwift

extension RecipeDetailView.RecipeDetailVM {
    func toggleFavorite() {
        guard let realmService = realmService else {
            errorMessage = "Realm service not available"
            return
        }
        
        let newIsFavorite = !recipe.isFavorite
        
        realmService.toggleFavorite(recipe: recipe, newIsFavorite: newIsFavorite)

        .subscribe(
            onCompleted: {
                DispatchQueue.main.async {
                    self.isFavorite = newIsFavorite
                    self.objectWillChange.send()
                }
            }, onError: { error in
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Error updating favorite status: \(error)"
                }
            })
        .disposed(by: disposeBag)
    }
}
