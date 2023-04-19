//
//  URLSessionFake.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 29/03/23.
//

import Foundation

//We will double the URLSession and URLSessionDataTask classes
//We create URLSessionFake which inherits from URLSession
class URLSessionFake: URLSession {
    //we will make our URLSessionFake configurable with these three data: data, response, error
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    //create subclasses of URLSession and URLSessionDataTask in which we will override the methods to allow modification of the implementation of dataTask(with:, completionHandler:) and resume()
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        //an instance of URLSessionDataTaskFake
        let task = URLSessionDataTaskFake()
        //we will pass it the completionHandler parameter
        task.completionHandler = completionHandler
        //we will pass the data to our task object
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        //an instance of URLSessionDataTaskFake
        let task = URLSessionDataTaskFake()
        //we will pass it the completionHandler parameter
        task.completionHandler = completionHandler
        //we will pass the data to our task object
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
}
//we create URLSessionDataTaskFake which inherits from URLSessionDataTask
class URLSessionDataTaskFake: URLSessionDataTask {
    //a property with returned bloc of data response
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    //properties of the three parameters of the closure
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    //We will do the overrides of both methods resume and cancel
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    override func cancel() {}
}
