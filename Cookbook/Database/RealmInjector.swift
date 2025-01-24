//
//  RealmInjector.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 12/19/24.
//

import Swinject

class Database {
    static let shared = Database()
    
    let container = Container()
    
    private init() {
        container.register(RealmServiceProtocol.self, name: "meal") { _ in
            try! RealmService(databaseName: "MealDatabase")
        }.inObjectScope(.container)
        
        container.register(RealmServiceProtocol.self, name: "drink") { _ in
            try! RealmService(databaseName: "DrinkDatabase")
        }.inObjectScope(.container)
        
        container.register(RealmServiceProtocol.self, name: "own") { _ in
            try! RealmService(databaseName: "OwnRecipesDatabase")
        }.inObjectScope(.container)
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(T.self)
    }
}
