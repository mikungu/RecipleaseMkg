//
//  Recherche.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import Foundation
import CoreData
import Alamofire

// MARK: - RecipesSearch
struct RecipesSearch: Decodable {
    let _links: Links
    let hits: [Hits]
}

// MARK: - Hit
struct Hits: Decodable {
    let recipe: Recipe
}

// MARK: - Next
struct Next: Decodable {
    let href: String
}

// MARK: - Recipe
struct Recipe: Decodable {
    let label: String
    let image: String
    let url: String
    let yield: Double
    let ingredientLines: [String]
    let totalTime: Int?
}

// MARK: - RecipesSearchLinks
struct Links: Decodable {
    let next: Next
}

final class SearchModel {
    //MARK: -Property
    private let ingredientModel = IngredientModel.shared
    private let apiService : APIService
    //MARK: -Lifecycle
    init ( apiService : APIService = APIService()) {
        self.apiService = apiService
    }
    
    //MARK: -Accessible
    var recipes = [Recipe] ()
    
    //function getRecipe where we precise the url, method and callback to launch a call API
    func getRecipe(completion: @escaping (Result<Recipe, Error>) -> Void) {
        
        ingredientModel.getIngredient(callback: {[weak self] ingredients in
            
            var ingredientText = ""
            for ingredient in ingredients {
                if let name = ingredient.name
                {
                    ingredientText += name + ","
                }
            }
            print (ingredientText)
        
            let url = "https://api.edamam.com/api/recipes/v2?q=\(ingredientText)&app_key=0ee60bcbccec37f058f54e1b6f327609&_cont=CHcVQBtNNQphDmgVQntAEX4BYVFtBwUPR2RAA2QXZVx0BgUCUXlSUTcWMAB2BQRWFWZGUmpGZARyV1cPEDRFVmcaNQB6DQsVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=public&app_id=89292498"
            print (url)
            let method: HTTPMethod = .get
            
            let callback: (Result<RecipesSearch, Error>)-> Void = {  result in
                switch result {
                case .success(let model):
                    print(model)
                    self?.recipes = model.hits.map { $0.recipe }
                    completion(.success(model.hits[0].recipe))
                case .failure(let error):
                    guard let error = error as? APIError else { break }
                    print(error)
                    completion (.failure(error))
                }
                
            }
            self?.apiService.makeCall(urlString: url, method: method, completion: callback)
            
        })
    }
}

