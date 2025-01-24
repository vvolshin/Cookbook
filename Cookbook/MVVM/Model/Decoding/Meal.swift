//
//  Meal.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/7/25.
//

import Foundation

struct Meal: RecipeItem {
    var strID: String
    var strName: String?
    var strThumbnail: String?
    var strCategory: String?
    var strInstructions: String?
    var ingredients: [String?] = []
    var measures: [String?] = []
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MealCodingKeys.self)
        self.strID = try container.decode(String.self, forKey: .idMeal)
        self.strName = try container.decode(String.self, forKey: .strMeal)
        self.strThumbnail = try container.decode(String.self, forKey: .strMealThumb)
        self.strCategory = try container.decode(String.self, forKey: .strCategory)
        self.strInstructions = try container.decode(String.self, forKey: .strInstructions)
        
        try decodeIngredientsAndMeasures(from: decoder)
        synchronizeIngredientsAndMeasures()
    }
}
