//
//  RecipeItemProtocol.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/7/25.
//

import Foundation

protocol RecipeItem: Decodable {
    var strID: String { get }
    var strName: String? { get }
    var strThumbnail: String? { get }
    var strCategory: String? { get }
    var strInstructions: String? { get }
    var ingredients: [String?] { get set }
    var measures: [String?] { get set }
    
    mutating func decodeIngredientsAndMeasures(from decoder: Decoder) throws
    mutating func synchronizeIngredientsAndMeasures()
    func toRealmModel() -> Recipe
}
