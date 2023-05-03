//
//  IngredientTextCase.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 30/03/23.
//

import Foundation
import XCTest
@testable import RecipleaseMkg

class IngredientTextCase: XCTestCase {
    
    func testgetIngredient() {
        let context = CoreDataStackIngrTest.testContext
        let fakeDataManagement = CoreDataGenericService<Ingredients>(context: context)
        let ingredientModel = IngredientModel(coreDataGenericService: fakeDataManagement)
        ingredientModel.getIngredient { ingredients in
            XCTAssertNotNil(ingredients)
            XCTAssertEqual(ingredients, [])
        }
    }
    
    func testSaveIngredientAndGetIngredient() {
        let context = CoreDataStackIngrTest.testContext
        let fakeDataManagement = CoreDataGenericService<Ingredients>(context: context)
        let ingredientModel = IngredientModel(coreDataGenericService: fakeDataManagement)
        
        let ingredient1 = "lemon"
        ingredientModel.saveIngredient(named: ingredient1, completion: { ingredients in
           print (ingredients)
            XCTAssertEqual(ingredients[0].name, ingredient1)
            XCTAssertTrue(ingredients.count == 1)
        })
        
        ingredientModel.getIngredient{ ingredients in
            print (ingredients)
            XCTAssertNotNil(ingredients)
            XCTAssertEqual(ingredients[0].name, ingredient1)
        }
        
        let ingredient2 = "cheese"
        ingredientModel.saveIngredient(named: ingredient2, completion: { ingredients in
            print (ingredient2)
            XCTAssertEqual(ingredients[0].name, ingredient2)
            XCTAssertTrue (ingredients.count == 1)
        })
        
        
    }
    
    func testDeleteIngredient() {
        let context = CoreDataStackIngrTest.testContext
        let fakeDataManagement = CoreDataGenericService<Ingredients>(context: context)
        let ingredientModel = IngredientModel(coreDataGenericService: fakeDataManagement)
        
        let ingredient1 = "lemon"
        ingredientModel.saveIngredient(named: ingredient1, completion: { ingredients in
           print (ingredients)
            XCTAssertEqual(ingredients[0].name, ingredient1)
            XCTAssertTrue(ingredients.count == 1)
        })
        
        ingredientModel.getIngredient{ ingredients in
            print (ingredients)
            XCTAssertNotNil(ingredients)
            XCTAssertEqual(ingredients[0].name, ingredient1)
        }
        
        ingredientModel.deleteIngredient(completion: { ingredients in
            print (ingredients)
            XCTAssertNotNil(ingredients)
            XCTAssertTrue(ingredients.count == 0)
            XCTAssertEqual(ingredients, [])
            
        })
    }
}

