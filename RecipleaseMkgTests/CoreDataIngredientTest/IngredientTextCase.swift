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
        let fakeDataManagement = IngredientModel(context: context)
        
        fakeDataManagement.getIngredient { ingredients in
            XCTAssertNotNil(ingredients)
            XCTAssertEqual(ingredients, [])
        }
    }
    
    func testSaveIngredientAndGetIngredient() {
        let context = CoreDataStackIngrTest.testContext
        let fakeDataManagement = IngredientModel(context: context)
        
        let ingredient1 = "lemon"
        fakeDataManagement.saveIngredient(named: ingredient1, callback: { ingredients in
            print (ingredients)
            XCTAssertEqual(ingredients[0].name, ingredient1)
            XCTAssertTrue(ingredients.count == 1)
        })
        
        fakeDataManagement.getIngredient{ ingredients in
            print (ingredients)
            XCTAssertNotNil(ingredients)
            XCTAssertEqual(ingredients[0].name, ingredient1)
        }
        
        let ingredient2 = "cheese"
        fakeDataManagement.saveIngredient(named: ingredient2, callback: { ingredients in
            print (ingredient2)
            XCTAssertEqual(ingredients[0].name, ingredient2)
            XCTAssertTrue (ingredients.count == 1)
        })
        
        
    }
    
    func testDeleteIngredient() {
        let context = CoreDataStackIngrTest.testContext
        let fakeDataManagement = IngredientModel(context: context)
        
        
        fakeDataManagement.deleteIngredient(callback: { ingredients in
            print (ingredients)
            XCTAssertNotNil(ingredients)
            XCTAssertTrue(ingredients.count == 0)
            XCTAssertEqual(ingredients, [])
            
        })
    }
}

