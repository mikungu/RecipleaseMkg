//
//  FavoriteModelTest.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 03/04/23.
//

import Foundation
@testable import RecipleaseMkg
import CoreData
import XCTest

class FavoriteModelTest: XCTestCase {
    
    func testAddAndDeleteFavorite() {
        let context = TestCoreDataFavorite.testContext
        let fakeDataManagement = CoreDataGenericService2<FavoritesRecipes>(context: context)
        let favoriteModel = FavoriteModel(coreDataGenericService: fakeDataManagement)
        
        let label = UUID().uuidString
        let recipe = makeRecipe(label: label)
        favoriteModel.addFavorite(recipe: recipe)
        print(label)
        XCTAssertNotNil(recipe)
        var savedToFavorite = favoriteModel.checkIfFavorite(recipeName: label)
        XCTAssertTrue(savedToFavorite)
        print(savedToFavorite)
        favoriteModel.deleteFromFavorite(recipeName: label)
        print ("Calling... 22")
        print(recipe)
        savedToFavorite = favoriteModel.checkIfFavorite(recipeName: label)
        XCTAssertFalse(savedToFavorite)
    }
    
    func testFavoriteWithNoTotalTime() {
        let context = TestCoreDataFavorite.testContext
        let fakeDataManagement = CoreDataGenericService2<FavoritesRecipes>(context: context)
        let favoriteModel = FavoriteModel(coreDataGenericService: fakeDataManagement)
        
        let label = UUID().uuidString
        let recipe = makeRecipe(label: label, totalTime: nil)
        favoriteModel.addFavorite(recipe: recipe)
            print("Calling")
            let isFavorite = favoriteModel.checkIfFavorite(recipeName: label)
            XCTAssertTrue(isFavorite)
            favoriteModel.fetchFavorites { recipes in
                XCTAssertTrue(recipes.count == 1)
                XCTAssertTrue(recipes[0].totalTime == 0)
            }
    }
    
    func testAdd2FavoritesAndFetchThem() {
        let context = TestCoreDataFavorite.testContext
        let fakeDataManagement = CoreDataGenericService2<FavoritesRecipes>(context: context)
        let favoriteModel = FavoriteModel(coreDataGenericService: fakeDataManagement)
        
        let label1 = UUID().uuidString
        let label2 = UUID().uuidString
        let recipe1 = makeRecipe(label: label1)
        let recipe2 = makeRecipe(label: label2)
        
        favoriteModel.addFavorite(recipe: recipe1)
            let savedToFavorite1 = favoriteModel.checkIfFavorite(recipeName: label1)
            XCTAssertTrue(savedToFavorite1)
        
        favoriteModel.addFavorite(recipe: recipe2)
            let savedToFavorite2 = favoriteModel.checkIfFavorite(recipeName: label2)
            XCTAssertTrue(savedToFavorite2)
        
        favoriteModel.fetchFavorites { recipes in
            XCTAssertNotNil(recipes)
            XCTAssertTrue(recipes.count == 2)
            XCTAssertTrue(recipe1.label == label1)
            XCTAssertTrue(recipe2.label == label2)
        }
    }
    
    func makeRecipe(label: String, totalTime: Int? = 20) -> Recipe {
        return Recipe(label: label, image: UUID().uuidString, url: UUID().uuidString, yield: Double.random(in: 0...50), ingredientLines: [UUID().uuidString], totalTime: totalTime)
    }
}

