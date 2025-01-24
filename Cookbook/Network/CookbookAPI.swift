//
//  RecipesAPI.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 12/27/24.
//

import Foundation
import RxSwift

enum CookbookAPI {
    private static let agent = NetworkAgent()
    
    private static func buildURL(for char: Character, base: APIEnvironment.Environment) -> URL? {
        guard let baseURL = URL(string: APIEnvironment.getEnvironment(for: base)) else {
            return nil
        }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = "/api/json/v1/1/search.php"
        components?.queryItems = [
            URLQueryItem(name: "f", value: "\(char)")
        ]
        
        return components?.url
    }
}

extension CookbookAPI {
    static func fetchMeals() -> Observable<[Recipe]> {
        let characters = Array("0123456789abcdefghijklmnopqrstuvwxyz")
        
        let publishers = characters.compactMap { ch -> Observable<[Recipe]>? in
            guard let url = buildURL(for: ch, base: .meal) else {
                return nil
            }
            return agent.run(url: url, type: .meals)
        }
        
        return Observable.merge(publishers)
            .asObservable()
    }
    
    static func fetchDrinks() -> Observable<[Recipe]> {
        let characters = Array("0123456789abcdefghijklmnopqrstuvwxyz")
        
        let publishers = characters.compactMap { ch -> Observable<[Recipe]>? in
            guard let url = buildURL(for: ch, base: .drink) else {
                return nil
            }
            return agent.run(url: url, type: .drinks)
        }
        
        return Observable.merge(publishers)
            .asObservable()
    }
}
