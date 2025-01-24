//
//  OwnTabVM.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/22/25.
//

import Foundation
import Realm
import RxSwift

extension OwnView {
    final class OwnVM: ObservableObject, RecipeProviderProtocol {
        @Published var recipes: [Recipe] = []
        @Published var categories: [String : Int] = [:]
        @Published var errorMessage: String?
        
        internal let disposeBag = DisposeBag()
        internal var ownRealmService = Database.shared.container.resolve(RealmServiceProtocol.self, name: "own")
        
    }
}
