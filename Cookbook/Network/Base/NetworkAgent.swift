//
//  NetworkAgent.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 12/26/24.
//

import RxSwift

struct NetworkAgent {    
    func run(url: URL, type: ResponseType) -> Observable<[Recipe]> {
        return Observable.create { observer in
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error {
                    observer.onError(NetworkError.requestFailed(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(NetworkError.badServerResponse)
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    observer.onError(NetworkError.badServerResponse)
                    print("Server responded with status code: \(httpResponse.statusCode)")
                    return
                }
                
                guard let data else {
                    observer.onError(NetworkError.noData)
                    return
                }
                
                do {
                    switch type {
                    case .meals:
                        let decodedResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
                        let recipes = decodedResponse.meals?.compactMap { $0.toRealmModel() } ?? []
                        observer.onNext(recipes)
                        observer.onCompleted()
                    case .drinks:
                        let decodedResponse = try JSONDecoder().decode(DrinksResponse.self, from: data)
                        let recipes = decodedResponse.drinks?.compactMap { $0.toRealmModel() } ?? []
                        observer.onNext(recipes)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(NetworkError.decodingError)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
