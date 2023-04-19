//
//  FavoriteModel.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 16/03/23.
//

import Foundation

import CoreData

class FavoriteModel {
    
    static let shared = FavoriteModel()
    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: "FavoritesRecipesCoreData")) {
        self.persistentContainer = container
        persistentContainer.loadPersistentStores { description, error in
            if error != nil {
                print("Failed to init core data")
            }
        }
    }
    
    func fetchFavorites(completion: @escaping ([Recipe]) -> Void) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesRecipes")
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            var favoriteRecipes: [Recipe] = []
            for favorite in result as! [NSManagedObject] {
                guard let label = favorite.value(forKey: "label") as? String else { return }
                guard let image = favorite.value(forKey: "image") as? String else { return }
                guard let url = favorite.value(forKey: "url") as? String else { return }
                guard let yield = favorite.value(forKey: "yield") as? String else { return }
                guard let ingredientLinesString = favorite.value(forKey: "ingredientLines") as? String else { return }
                let ingredientLines = ingredientLinesString.components(separatedBy: "$j%^")
                guard let totalTime = favorite.value(forKey: "totalTime") as? String else {return}
                let recipeCD = Recipe(label: label,
                                      image: image,
                                      url: url,
                                      yield:Double(yield) ?? 4,
                                      ingredientLines: ingredientLines,
                                      totalTime: Int(totalTime))
                favoriteRecipes.append(recipeCD)
            }
            completion(favoriteRecipes)
            
        } catch let error {
            completion([])
            print("Error getting favorites == \(error.localizedDescription)")
        }
    }
    
    func checkIfFavorite(recipeName: String) -> Bool {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesRecipes")
        fetchRequest.predicate = NSPredicate(format: "label = %@", recipeName )
        
        let result = try? managedObjectContext.fetch(fetchRequest)
        return result?.count == 1 ? true: false
    }
    
    func addFavorite(recipe: Recipe) {
        let managedObjectContext = persistentContainer.viewContext
        guard let recipeEntity = NSEntityDescription.entity(forEntityName: "FavoritesRecipes", in: managedObjectContext) else { return }
        let favoriteEntity = NSManagedObject(entity: recipeEntity, insertInto: managedObjectContext)
        favoriteEntity.setValue(recipe.image, forKey: "image")
        favoriteEntity.setValue(recipe.label, forKey: "label")
        favoriteEntity.setValue("\(recipe.totalTime ?? 0 )", forKey: "totalTime")
        favoriteEntity.setValue("\((recipe.ingredientLines).joined(separator: "$j%^"))", forKey: "ingredientLines")
        favoriteEntity.setValue(recipe.url, forKey: "url")
        favoriteEntity.setValue("\(recipe.yield)", forKey: "yield")
        
        try? managedObjectContext.save()
    }
    
    func deleteFromFavorite(recipeName: String) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesRecipes")
        fetchRequest.predicate = NSPredicate(format: "label = %@", recipeName)
        let result = try? managedObjectContext.fetch(fetchRequest)
        for favorite in result as! [NSManagedObject] {
            managedObjectContext.delete(favorite)
            
            try? managedObjectContext.save()
        }
    }
}
