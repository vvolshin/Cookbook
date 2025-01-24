//
//  recipeRealm.swift
//  testRealm
//
//  Created by Vitaly Volshin on 11/15/24.
//

import RealmSwift
import RxSwift

class RealmService: RealmServiceProtocol {
    private let configuration: Realm.Configuration
    
    init(databaseName: String) throws {
        let fileManager = FileManager.default
        guard let fileURL = fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("\(databaseName).realm") else {
            throw RealmError.createDatabaseError
        }
        
        if fileManager.fileExists(atPath: fileURL.path) {
            print("Open database: \(fileURL.path)")
        }
        
        self.configuration = Realm.Configuration(fileURL: fileURL)
    }
    
    private func createRealm() throws -> Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            throw RealmError.initializationFailed
        }
    }
    
    func create(recipes: [Recipe]) -> Completable {
        Completable.create { completable in
            DispatchQueue.global(qos: .background).async {
                do {
                    let realm = try self.createRealm()
                    
                    try realm.write {
                        for recipe in recipes {
                            if realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) != nil {
                                continue
                            } else {
                                realm.add(recipe)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                } catch RealmError.initializationFailed {
                    DispatchQueue.main.async {
                        completable(.error(RealmError.initializationFailed))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completable(.error(RealmError.unknownError))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func observeCategories() -> Observable<[String : Int]> {
        return Observable.create { observer in
            do {
                let realm = try self.createRealm()
                
                let results: Results<Recipe> = realm.objects(Recipe.self)
                    .sorted(byKeyPath: "name", ascending: true)
                
                let notificationToken = results.observe { change in
                    switch change {
                    case .initial(let recipes):
                        observer.onNext(self.categoriesCount(from: Array(recipes)))
                    case .update(let recipes, _, _, _):
                        observer.onNext(self.categoriesCount(from: Array(recipes)))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    notificationToken.invalidate()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    func observeFavoriteCategories() -> Observable<[String : Int]> {
        return Observable.create { observer in
            do {
                let realm = try self.createRealm()
                
                let results: Results<Recipe> = realm.objects(Recipe.self)
                    .sorted(byKeyPath: "name", ascending: true)
                    .filter("isFavorite == true")
                
                let notificationToken = results.observe { change in
                    switch change {
                    case .initial(let recipes):
                        observer.onNext(self.categoriesCount(from: Array(recipes)))
                    case .update(let recipes, _, _, _):
                        observer.onNext(self.categoriesCount(from: Array(recipes)))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    notificationToken.invalidate()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    private func categoriesCount(from recipes: [Recipe]) -> [String: Int] {
        var categoryCount: [String: Int] = [:]
        var totalCount: Int = 0
        
        for recipe in recipes {
            let category = recipe.category
            categoryCount[category ?? "Unknown", default: 0] += 1
            totalCount += 1
        }
        
        categoryCount["All"] = totalCount
        
        return categoryCount
    }
    
    func observeRecipes(in category: String) -> Observable<[Recipe]> {
        return Observable.create { observer in
            do {
                let realm = try self.createRealm()
                
                let results: Results<Recipe>
                
                if category == "All" {
                    results = realm.objects(Recipe.self)
                } else {
                    results = realm.objects(Recipe.self)
                        .filter("category == %@", category)
                }
                
                let sortedResults = results.sorted(byKeyPath: "name", ascending: true)
                
                let notificationToken = sortedResults.observe { change in
                    switch change {
                    case .initial(let recipes):
                        observer.onNext(Array(recipes))
                    case .update(let recipes, _, _, _):
                        observer.onNext(Array(recipes))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    notificationToken.invalidate()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    func observeFavoriteRecipes(in category: String) -> Observable<[Recipe]> {
        return Observable.create { observer in
            do {
                let realm = try self.createRealm()
                
                let results: Results<Recipe>
                
                if category == "All" {
                    results = realm.objects(Recipe.self)
                        .filter("isFavorite == true")
                } else {
                    results = realm.objects(Recipe.self)
                        .filter("category == %@", category)
                        .filter("isFavorite == true")
                }
                
                let sortedResults = results.sorted(byKeyPath: "name", ascending: true)
                
                let notificationToken = sortedResults.observe { change in
                    switch change {
                    case .initial(let recipes):
                        observer.onNext(Array(recipes))
                    case .update(let recipes, _, _, _):
                        observer.onNext(Array(recipes))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    notificationToken.invalidate()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    func searchRecipes(by name: String) -> Observable<[Recipe]> {
        return Observable.create { observer in
            do {
                guard !name.isEmpty else {
                    observer.onNext([])
                    observer.onCompleted()
                    return Disposables.create()
                }
                
                let realm = try self.createRealm()
                
                let results: Results<Recipe> = realm.objects(Recipe.self)
                    .filter("name CONTAINS[c] %@", name)
                
                let sortedResults = results.sorted(byKeyPath: "name", ascending: true)
                
                if sortedResults.isEmpty {
                    observer.onNext([])
                }
                
                let notificationToken = sortedResults.observe { change in
                    switch change {
                    case .initial(let recipes):
                        observer.onNext(Array(recipes))
                    case .update(let recipes, _, _, _):
                        observer.onNext(Array(recipes))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    notificationToken.invalidate()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    func toggleFavorite(recipe: Recipe, newIsFavorite: Bool?) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(RealmError.unknownError))
                return Disposables.create()
            }
            
            do {
                let realm = try self.createRealm()
                
                guard let realmRecipe = realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) else {
                    throw RealmError.recipeNotFound
                }
                
                try realm.write {
                    if let newIsFavorite = newIsFavorite {
                        realmRecipe.isFavorite = newIsFavorite
                    }
                    
                    realm.add(realmRecipe, update: .modified)
                    
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completable(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func update(recipe: Recipe, newName: String?, newImage: String?, newInstructions: String?, newIngredients: [String]?, newMeasures: [String]?) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(RealmError.unknownError))
                return Disposables.create()
            }
            
            do {
                let realm = try self.createRealm()
                
                guard let realmRecipe = realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) else {
                    throw RealmError.recipeNotFound
                }
                
                try realm.write {
                    if let newName = newName {
                        realmRecipe.name = newName
                    }
                    
                    if let newImage = newImage {
                        realmRecipe.thumbnail = newImage
                    }
                    
                    if let newInstructions = newInstructions {
                        realmRecipe.instructions = newInstructions
                    }
                    
                    if let newIngredients = newIngredients {
                        let ingredientsList = RealmSwift.List<String>()
                        ingredientsList.append(objectsIn: newIngredients)
                        realmRecipe.ingredients = ingredientsList
                    }
                    
                    if let newMeasures = newMeasures {
                        let measuresList = RealmSwift.List<String>()
                        measuresList.append(objectsIn: newMeasures)
                        realmRecipe.measures = measuresList
                    }

                    realm.add(realmRecipe, update: .modified)
                    
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completable(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func delete(recipe: Recipe) -> Completable {
        return Completable.create { completable in
            DispatchQueue.global(qos: .background).async {
                do {
                    let realm = try self.createRealm()
                    
                    guard realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) != nil else {
                        throw RealmError.recipeNotFound
                    }
                    
                    try realm.write {
                        realm.delete(recipe)
                    }
                    
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                } catch RealmError.recipeNotFound {
                    DispatchQueue.main.async {
                        completable(.error(RealmError.recipeNotFound))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completable(.error(RealmError.deleteError))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAll() -> Completable {
        Completable.create { completable in
            do {
                let realm = try self.createRealm()
                
                try realm.write {
                    realm.deleteAll()
                    
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
            } catch {
                completable(.error(RealmError.deleteError))
            }
            return Disposables.create()
        }
    }
}
