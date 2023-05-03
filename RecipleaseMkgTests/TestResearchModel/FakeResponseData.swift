//
//  FakeResponseData.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 29/03/23.
//

import Foundation

@testable import RecipleaseMkg
import Alamofire

//The class FakeResponseData whose role is to manage the test data
class FakeResponseData: HTTPClient {
    func request<T>(urlString: String, method: RecipleaseMkg.HTTPMethod, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let bundle = Bundle(for: RecipleaseMkgTests.self)
        let url = bundle.url(forResource: "Edamam", withExtension: "json")!
        let json = try! Data(contentsOf: url)
        
        let dataResponse = AFDataResponse<Data?>.init(request: nil, response: nil, data: json, metrics: nil, serializationDuration: .zero, result: .success(json))
        
        self.decodeRecipeResponse(from: dataResponse, completion: completion)
    }
    
}
