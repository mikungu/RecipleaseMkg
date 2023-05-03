//
//  IngredientModel.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import Foundation
import CoreData
import UIKit


class IngredientModel {
    let coreDataGenericService : CoreDataGenericService<Ingredients>
    
    init(coreDataGenericService: CoreDataGenericService<Ingredients> = CoreDataGenericService(context: CoreDataStack.sharedInstance.persistentContainer.viewContext)) {
        self.coreDataGenericService = coreDataGenericService
    }
    
    //let coreDataService = CoreDataGenericService<Ingredients>(context: CoreDataStack.sharedInstance.persistentContainer.viewContext)
    
    func saveIngredient (named name: String, completion: @escaping ([Ingredients]) -> Void) {
        let ingredient = coreDataGenericService.createObject()
        ingredient.name = name
        coreDataGenericService.save()
        completion ([ingredient])
    }
    
    func getIngredient (completion: @escaping ([Ingredients]) -> Void) {
        let ingredients = coreDataGenericService.getObject()
        completion (ingredients)
        
    }
    
    func deleteIngredient (completion: @escaping ([Ingredients]) -> Void) {
        coreDataGenericService.deleteObject()
    }
}

