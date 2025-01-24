//
//  ResponseFromAPI.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

extension NetworkAgent {
    struct MealsResponse: Decodable {
        let meals: [Meal]?
    }
    
    struct DrinksResponse: Decodable {
        let drinks: [Drink]?
    }
    
    enum ResponseType {
        case meals, drinks
    }
}
