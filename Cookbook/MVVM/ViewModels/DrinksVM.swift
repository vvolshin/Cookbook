//
//  DrinksVM.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/22/25.
//

import Foundation
import Realm
import RxSwift

extension DrinksView {
    final class DrinksVM: ObservableObject, RecipeProviderProtocol {
        @Published var drinks: [Recipe] = []
        @Published var categories: [String : Int] = [:]
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        
        internal let disposeBag = DisposeBag()
        internal var drinkRealmService = Database.shared.container.resolve(RealmServiceProtocol.self, name: "drink")
    }
}
