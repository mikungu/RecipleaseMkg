//
//  FavoriteModel.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 16/03/23.
//

import Foundation

import CoreData

class FavoriteModel {
    
    let coreDataGenericService : CoreDataGenericService2<FavoritesRecipes>
    
    init(coreDataGenericService: CoreDataGenericService2<FavoritesRecipes> = CoreDataGenericService2(context: CoreDataStackFav.sharedInstance.persistentContainer.viewContext)) {
        self.coreDataGenericService = coreDataGenericService
    }
   // let coreDataService = CoreDataGenericService2<FavoritesRecipes>()
    
    func fetchFavorites(completion: @escaping ([Recipe]) -> Void) {
        let result = coreDataGenericService.getObject()
        var favoriteRecipes: [Recipe] = []
        for favorite in result {
            guard let label = favorite.value(forKey: "label") as? String else { return }
            guard let image = favorite.value(forKey: "image") as? String else { return }
            guard let url = favorite.value(forKey: "url") as? String else { return }
            guard let yield = favorite.value(forKey: "yield") as? String else { return }
            guard let ingredientLinesString = favorite.value(forKey: "ingredientLines") as? String else { return }
            let ingredientLines = ingredientLinesString.components(separatedBy: "$j%^")
            guard let totalTime = favorite.value(forKey: "totalTime") as? String else {return}
            let recipeCD = Recipe(label: label, image: image, url: url, yield: Double(yield) ?? 4, ingredientLines: ingredientLines, totalTime: Int(totalTime))
            favoriteRecipes.append(recipeCD)
        }
        completion(favoriteRecipes)
    }
    
    func checkIfFavorite(recipeName: String) -> Bool {
        let result = coreDataGenericService.checkObject(recipeName: recipeName)
        return result.count == 1 ? true: false
    }
    
    func addFavorite(recipe: Recipe) {
        let managedObjectContext = coreDataGenericService.favoriteContext
        guard let recipeEntity = NSEntityDescription.entity(forEntityName: "FavoritesRecipes", in: managedObjectContext) else { return }
        let favoriteEntity = NSManagedObject(entity: recipeEntity, insertInto: managedObjectContext)
        favoriteEntity.setValue(recipe.image, forKey: "image")
        favoriteEntity.setValue(recipe.label, forKey: "label")
        favoriteEntity.setValue("\(recipe.totalTime ?? 0 )", forKey: "totalTime")
        favoriteEntity.setValue("\((recipe.ingredientLines).joined(separator: "$j%^"))", forKey: "ingredientLines")
        favoriteEntity.setValue(recipe.url, forKey: "url")
        favoriteEntity.setValue("\(recipe.yield)", forKey: "yield")
        
        coreDataGenericService.save()
    }
    
    func deleteFromFavorite(recipeName: String) {
        coreDataGenericService.deleteObject(recipeName: recipeName)
    }
}
