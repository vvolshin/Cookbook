//
//  APIEnvironment.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

struct APIEnvironment {
    enum Environment {
        case meal, drink

        var baseURL: String {
            switch self {
            case .meal:
                return APISource.mealsBaseURL
            case .drink:
                return APISource.drinksBaseURL
            }
        }
    }
    
    static func getEnvironment(for environment: Environment) -> String {
        return environment.baseURL
    }
}
