//
//  APIService.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 04/03/23.
//

import Foundation

import Alamofire

enum HTTPMethod: String {
    case get = "Get"
    case post = "Post"
}

enum APIError: Error {
    case errorNetWork
    case parsing
    case anyerror
}

protocol HTTPClient {
    func request <T: Decodable> (urlString: String, method: HTTPMethod, completion: @escaping (Result<T, Error>) -> Void)
    func decodeRecipeResponse <T: Decodable>(from response: AFDataResponse<Data?>, completion: @escaping (Result<T, Error>) -> Void)
}

extension HTTPClient {
   
    func decodeRecipeResponse <T: Decodable> (from response: AFDataResponse<Data?>, completion: @escaping (Result<T, Error>) -> Void) {
        guard let data = response.data else {
            completion (.failure(APIError.errorNetWork))
            return
        }
        do {
            let recipes = try JSONDecoder().decode(T.self, from: data)
            completion(.success(recipes))
        } catch {
            completion(.failure(APIError.parsing))
        }
    }
    
}


class APIService: HTTPClient {
    
    func request<T>(urlString: String, method: HTTPMethod, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        AF.request(urlString, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            self.decodeRecipeResponse(from: responseData, completion: completion)
        }
    }

}
