//
//  RecipeItemExtention.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

import Foundation

extension RecipeItem {
    mutating func decodeIngredientsAndMeasures(from decoder: Decoder) throws {
        let containerForDynamicKeys = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for i in 1...20 {
            let ingredient = try containerForDynamicKeys.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strIngredient\(i)")!)
            let measure = try containerForDynamicKeys.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strMeasure\(i)")!)
            
            if let ingredient = ingredient, !ingredient.trimmingCharacters(in: .whitespaces).isEmpty {
                ingredients.append(ingredient)
            }
            
            if let measure = measure, !measure.trimmingCharacters(in: .whitespaces).isEmpty {
                measures.append(measure)
            }
        }
    }
    
    mutating func synchronizeIngredientsAndMeasures() {
        while measures.count < ingredients.count {
            measures.append(nil)
        }
        
        for index in 0..<ingredients.count {
            if let ingredient = ingredients[index],
               !ingredient.isEmpty {
                if measures[index]?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
                    measures[index] = "on taste"
                }
            }
        }
    }
    
    func thumbnailData() -> Data? {
        guard let thumbnailURLString = strThumbnail,
              let url = URL(string: thumbnailURLString) else { return nil }
        return try? Data(contentsOf: url)
    }
    
    func toRealmModel() -> Recipe {
        let realmRecipe = Recipe()
        realmRecipe.id = strID
        realmRecipe.name = strName?.trimmingCharacters(in: .whitespaces)
        realmRecipe.thumbnail = strThumbnail
        realmRecipe.category = strCategory
        realmRecipe.instructions = strInstructions
        realmRecipe.ingredients.append(objectsIn: ingredients.compactMap { $0 })
        realmRecipe.measures.append(objectsIn: measures.compactMap { $0 })
        return realmRecipe
    }
}
