//
//  FakeResponseData.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 29/03/23.
//

import Foundation

//The class FakeResponseData whose role is to manage the test data
class FakeResponseData {
    //we simulate the response:
    //an instance of HTTPURLResponse with a code 200 when it's ok
    static let responseOK = HTTPURLResponse(url: URL(string: "www.openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    //an instance of HTTPURLResponse with a code 500 when it's not ok
    static let responseKO = HTTPURLResponse(url: URL(string: "www.openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    //we simulate the error
    class NetworkError: Error {}
    static let error = NetworkError()
    //we simulate the data:
    //EdamamRecipeData
    static var edamamRecipeCorrectData: Data {
        //a returned JSON
        //retrieve the package in which our file is located
        let bundle = Bundle(for: FakeResponseData.self)
        //we retrieve the URL at which our file is located by indicating the name and extension of the file we are looking for
        let url = bundle.url(forResource: "Edamam", withExtension: "json")
        //we retrieve the data contained at this url via Da's init(contentsOf: url) initializer
        let data = try! Data(contentsOf: url!)
        return data
    }
    //we simulate a damage JSON
    static let networkIncorrectData = "erreur".data(using: .utf8)!
    
}
