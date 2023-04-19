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
    case url
    case responseCode
    case invalidData
    case parsing
    case anyerror
}

class APIService {
    
    private let session: URLSession
    //make the task a property of our APIService class
    private var task : URLSessionDataTask?
    
    // MARK: - Lifecyle
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //MARK: -Accessible
    //we create the function that will allow us to make centralized API calls that takes url, method, callback as parameters.
    func makeCall <T: Decodable> (urlString: String, method: HTTPMethod, completion: @escaping (Result<T, Error>)->Void){
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.url))
            return
        }
        //we will be able to cancel the task if another task is launched
        task?.cancel()
        //we create a request
        //We initialize an instance of URLRequest by passing it our URL as a parameter
        var request = URLRequest(url: url)
        //We specify the chosen HTTP method with the httpMethod property of URLRequest
        request.httpMethod = method.rawValue
        //we are going to create a task, and more precisely an instance of URLSessionDataTask
        task = self.session.dataTask(with: request, completionHandler: { data, response, error in
            //return to Main Queue
            DispatchQueue.main.async {
                //we will check that there is no error
                guard error == nil else {
                    completion(.failure (APIError.anyerror))
                    return
                }
                //we will check that the status code of the response is indeed 200
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(APIError.responseCode))
                    return
                }
                //we will check if we have correct data
                guard let data = data else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                //we will decode data in JSON format to dictionary and others
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(APIError.parsing))
                }
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                }
            }
        })
        //we make the call here
        task?.resume()
    }
}
