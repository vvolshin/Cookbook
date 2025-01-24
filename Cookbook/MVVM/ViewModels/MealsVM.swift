//
//  MealsVM.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 12/27/24.
//

import Foundation
import Realm
import RxSwift

extension MealsView {
    final class MealsVM: ObservableObject, RecipeProviderProtocol {
        @Published var meals: [Recipe] = []
        @Published var categories: [String : Int] = [:]
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?
        
        internal let disposeBag = DisposeBag()
        internal var mealRealmService = Database.shared.container.resolve(RealmServiceProtocol.self, name: "meal")
    }
}
