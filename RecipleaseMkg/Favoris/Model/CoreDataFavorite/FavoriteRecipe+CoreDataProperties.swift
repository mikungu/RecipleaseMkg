//
//  FavoriteRecipe+CoreDataProperties.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 17/03/23.
//

import Foundation
import CoreData

extension FavoriteRecipe {
    @nonobjc
    public class override func fetchRequest() -> NSFetchRequest<FavoriteRecipe> {
        return NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteCoreData")
    }
    @NSManaged public var image: String?
    @NSManaged public var ingredientLines: [String]?
    @NSManaged public var label: String?
    @NSManaged public var totalTime: String?
    @NSManaged public var url: String?
    @NSManaged public var yield: String?
}
