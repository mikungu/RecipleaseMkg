//
//  RecipleaseMkgTests.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 29/03/23.
//

import XCTest

@testable import RecipleaseMkg

final class RecipleaseMkgTests: XCTestCase {
    
    
    //MARK: -Accessible
    let expectation = XCTestExpectation(description: "Wait for queue change")
    var ingredients: [String]!
    var recipes: [Recipe]!
    
    override func setUp() {
        super.setUp()
        ingredients = ["lemon", "cheese"]
    }
    //MARK: -Test
    //Test if there is an error
    func testGetRecipeShouldPostFailedCallbackIfError() {
        let recipe = APIService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        //When
        let recipeService = SearchModel(apiService: recipe)
        recipeService.getRecipe { result in
            //Then
            switch result {
            case .success(let value):
                print(value)
                XCTAssertNil(recipeService.recipes)
                self.expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTAssertNotNil(error)
                self.expectation.fulfill()
            }
            
        }
        wait (for: [expectation], timeout: 0.01)
        
    }
    
    func testGetRecipeShouldPostFailedCallbackIfNoData () {
        let recipe = APIService(session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let recipeService = SearchModel(apiService: recipe)
        recipeService.getRecipe { result in
            //Then
            switch result {
            case .success(let value):
                print(value)
                XCTAssertNil(recipeService.recipes)
                self.expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTAssertNotNil(error)
                self.expectation.fulfill()
            }
        }
        wait (for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectResponse() {
        let recipe = APIService(session: URLSessionFake(data: FakeResponseData.edamamRecipeCorrectData, response: FakeResponseData.responseKO, error: nil))
        //When
        let recipeService = SearchModel(apiService: recipe)
        recipeService.getRecipe { result in
            //Then
            switch result {
            case .success(let value):
                print(value)
                XCTAssertNil(value)
                self.expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTAssertNotNil(error)
                self.expectation.fulfill()
            }
            
        }
        wait (for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectData() {
        let recipe = APIService(session: URLSessionFake(data: FakeResponseData.networkIncorrectData, response: FakeResponseData.responseOK, error: nil))
        //When
        let recipeService = SearchModel(apiService: recipe)
        recipeService.getRecipe { result in
            //Then
            switch result {
            case .success(let value):
                print(value)
                XCTAssertNil(value)
                self.expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTAssertNotNil(error)
                self.expectation.fulfill()
            }
            
        }
        wait (for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostSuccessCallbackIfNoErrorAndCorrectData () {
        let recipe = APIService(session: URLSessionFake(data: FakeResponseData.edamamRecipeCorrectData, response: FakeResponseData.responseOK, error: nil))
        //When
        let recipeService = SearchModel(apiService: recipe)
        
        recipeService.getRecipe { result in
            //Then
            switch result {
            case .success(let value):
                print(value)
                XCTAssertTrue(true)
                XCTAssertEqual(value.label, "Spaghetti With Courgette, Lemon And Goats Cheese")
                XCTAssertEqual(value.image, "https://edamam-product-images.s3.amazonaws.com/web-img/7ff/7ff8f18d989f719c7a92a578588f5034.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEIX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIEFJ4qer9nMrxaRjoWHqezVnC3HWrfLbqugh7lsg3AnRAiEA2T81GBTLM%2Bz156DHaABceB9PUvHDJ0fMhZ9dNjvs3ioquQUIXRAAGgwxODcwMTcxNTA5ODYiDF1CFbjNbbDfSEnyLiqWBY69aBa7dZVw61wLFA%2Bx3XYgIVQ0VP1dXUUfp4C4qY3wuVSHjO9cyac9ND%2B5iMHEyi8juog3KCyQns%2FnjG7581bgns83LR855yNSaG1STHcs09Z3IBoU3SkSd6LMySu3SnZ7FHCDBhtVFwHT%2BTLy07J6EQ0uVJuSoLDC2QtkNUFO8a8g3vgEKuW6cjFFL%2F6Eg4KoCbfJtdt1l%2BRJdc4QIVkiTx5emO0rp5gjyVLAcnQdtvBzcl9t2GCnHhUvqt9cIqRAEwr3Vl%2FPKSSG6MOK2ecGCcQn8dHmRde1Cuu8LCLNQRYUBedToqZsqlaPSlEHIBJTHPC9g9HX5Losq0W7CiHkz36Yj67DAKFQP077r38YLVMdVfwEuPrXaM6iWtPdGJ1pyo95M7M9LKcyBrRmg5Il35egMIn1%2BAZXw4NmCEy3i6wyq%2BHFQW5Fe7eIO32tJXGI3%2BN92kcqDUlJrwKdxYRi8BAS5QXUmvCCz9jSXnJGezTYTByrEeX5zgLRsQMBJWYsSgOMYygIoE8vv2h3%2Bvh6LdS4soiuCzZg%2BFJX7DPLCHSscaGwwJdFEDH1N6EpmmQc%2B0IcufJdMojJ8DH%2F9%2BPGnfxTKHRX3LvmQh%2BgW%2BsMiC24HjVKmw%2B0HlZmcJem9AeOpA5BCPnnAw4Vmnz4h02ZijKLpQbQ676Wnv22qnoJFjaxW5K3HYdiFppF1PttF50sYiMZ43i2fh757%2BoDPUSIharhqGwh%2FDi4Rh0x82WWtMIhpXsoJflGRlzwZBtI%2B5X8Hmsyn11E96Uu33YWu%2FCi7lwFVS%2Fv9XZ9ZhDmx47%2B8gaGaeBfoifDzBHXn%2FE5fVuF1JabZppSmt9cBDn05EYK5XAMJyP4j17drBJ8lTWt8v79ty08MJ3UkKEGOrEBZ5bUOPcJYd0w1ZE1wtGciCkQ9pJqDOibWJ2xsAmLpCrdJw0utUTmLCTGbmHS2bG8HvG%2Fb4G1t6b6KrzseN%2FDELHGYTk0xm%2B5XTUqVrUdla5wvLaT8AyH%2Fnn6hK%2BOuSa23QjGx5Zqz8FshaxcUt1K0%2F7Lu3ECvMudBQUrWoVVMGHhUFgCF3M%2FEmNOOC5OIiPEkfIujYQmZ%2Bmg8NuMojEYbY2zudV%2Fzb9ZpiitvMhBWh0y&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230329T133252Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFGDPDDPL6%2F20230329%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=60680e28d50f40f92f075d5d04a339ef59811f5c5930c3d945024f8ea1cfa6d5")
                XCTAssertEqual(value.url, "http://www.mostlyeating.com/spaghetti-with-courgette-lemon-and-goats-cheese")
                XCTAssertEqual(value.ingredientLines, [
                    "200 g wholewheat spaghetti (dry weight)",
                    "2 medium courgettes (zucchini), ends removed and then cut into matchsticks or julienned",
                    "2 cloves garlic, finely chopped",
                    "1 tbsp olive oil",
                    "2 tbsp finely chopped mint leaves",
                    "100 g soft goats cheese, crumbled",
                    "zest of one unwaxed lemon, coarsely grated",
                    "optional - a pinch of chilli flakes",
                    "Black pepper to season"
                ])
                XCTAssertEqual(value.yield, 2.0)
                XCTAssertEqual(value.totalTime, 0)
                self.expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTAssertNil(error)
                self.expectation.fulfill()
            }
        }
        wait (for: [expectation], timeout: 0.05)
    }
}
