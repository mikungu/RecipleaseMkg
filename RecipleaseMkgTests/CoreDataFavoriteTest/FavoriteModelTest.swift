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
    var favoriteModel: FavoriteModel!
    var coreDataTaskFavorite: CoreDataStackFavorite!
    
    override func setUp () {
        super.setUp()
        coreDataTaskFavorite = TestCoreDataStack()
        favoriteModel = FavoriteModel(container: coreDataTaskFavorite.storeContainer)
        
    }
    
    func testAddAndDeleteFavorite() {
        guard let sut = favoriteModel else { return }
        let label = UUID().uuidString
        let recipe = makeRecipe(label: label)
        sut.addFavorite(recipe: recipe)
        print("Calling")
        var savedToFavorite = sut.checkIfFavorite(recipeName: label)
        XCTAssertTrue(savedToFavorite)
        
        sut.deleteFromFavorite(recipeName: label)
        print ("Calling... 22")
        savedToFavorite = sut.checkIfFavorite(recipeName: label)
        XCTAssertFalse(savedToFavorite)
    }
    
    func testFavoriteWithNoTotalTime() {
        guard let sut = favoriteModel else { return }
        let label = UUID().uuidString
        let recipe = makeRecipe(label: label, totalTime: nil)
        sut.addFavorite(recipe: recipe)
            print("Calling")
            let isFavorite = sut.checkIfFavorite(recipeName: label)
            XCTAssertTrue(isFavorite)
            sut.fetchFavorites { recipes in
                XCTAssertTrue(recipes.count == 1)
                XCTAssertTrue(recipes[0].totalTime == 0)
            }
    }
    
    func testAdd2FavoritesAndFetchThem() {
        guard let sut = favoriteModel else { return }
        let label1 = UUID().uuidString
        let label2 = UUID().uuidString
        let recipe1 = makeRecipe(label: label1)
        let recipe2 = makeRecipe(label: label2)
        
        sut.addFavorite(recipe: recipe1)
            let savedToFavorite1 = sut.checkIfFavorite(recipeName: label1)
            XCTAssertTrue(savedToFavorite1)
        
        sut.addFavorite(recipe: recipe2)
            let savedToFavorite2 = sut.checkIfFavorite(recipeName: label2)
            XCTAssertTrue(savedToFavorite2)
        
        sut.fetchFavorites { recipes in
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

