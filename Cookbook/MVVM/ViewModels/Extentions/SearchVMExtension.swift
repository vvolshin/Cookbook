//
//  SearchVMExtension.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/24/25.
//

import Foundation
import RxSwift

extension SearchView.SearchVM {
    func searchRecipesInRealm(by name: String) {
        self.realmService?.searchRecipes(by: name)
            .subscribe(
                onNext: { [weak self] readRecipe in
                    DispatchQueue.main.async {
                        self?.searchedRecipes = readRecipe
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
