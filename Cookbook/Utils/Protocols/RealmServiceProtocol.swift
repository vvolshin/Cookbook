//
//  RealmServiceProtocol.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

import RxSwift

protocol RealmServiceProtocol {
    func create(recipes: [Recipe]) -> Completable
    func observeCategories() -> Observable<[String : Int]>
    func observeFavoriteCategories() -> Observable<[String : Int]>
    func observeRecipes(in category: String) -> Observable<[Recipe]>
    func observeFavoriteRecipes(in category: String) -> Observable<[Recipe]>
    func searchRecipes(by name: String) -> Observable<[Recipe]>
    func toggleFavorite(recipe: Recipe, newIsFavorite: Bool?) -> Completable
    func update(recipe: Recipe, newName: String?, newImage: String?, newInstructions: String?, newIngredients: [String]?, newMeasures: [String]?) -> Completable
    func delete(recipe: Recipe) -> Completable
    func deleteAll() -> Completable
}
