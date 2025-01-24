//
//  RecipeProviderProtocol.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/15/25.
//

protocol RecipeProviderProtocol {
    func viewModelForRecipe(_ recipe: Recipe, recipeType: RecipeType) -> RecipeDetailView.RecipeDetailVM
}

extension RecipeProviderProtocol {
    func viewModelForRecipe(_ recipe: Recipe, recipeType: RecipeType) -> RecipeDetailView.RecipeDetailVM {
        return RecipeDetailView.RecipeDetailVM(recipe: recipe, recipeType: recipeType)
    }
}
