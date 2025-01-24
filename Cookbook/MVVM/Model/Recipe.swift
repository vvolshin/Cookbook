//
//  Recipe.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/7/25.
//

import RealmSwift

class Recipe: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String?
    @Persisted var thumbnail: String?
    @Persisted var category: String?
    @Persisted var instructions: String?
    @Persisted var ingredients: List<String>
    @Persisted var measures: List<String>
    @Persisted var isFavorite: Bool = false

    convenience init(id: String, name: String?, thumbnail: String?, category: String?, instructions: String?, ingredients: [String], measures: [String]) {
        self.init()
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.category = category
        self.instructions = instructions
        self.ingredients.append(objectsIn: ingredients)
        self.measures.append(objectsIn: measures)
    }
}
