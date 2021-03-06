//
//  Networking.swift
//  RazeCore
//
//  Created by Raisa Meneses on 1/19/21.
//

import Foundation
protocol NetworkSession {
    func get(from url: URL, completionHandler: @escaping(Data?, Error?)-> Void)
    func post(with request: URLRequest, completionHandler: @escaping(Data?, Error?)-> Void)
}
extension URLSession: NetworkSession {
    func post(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: request){data, _, error in
            completionHandler(data, error)
        }
        task.resume()
    }

 
    func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url){data, _, error in
            completionHandler(data, error)
        }
        task.resume()
    }
    
    
}
extension RazeCore{
    public class Networking {
        
        /// Responsible for handling all networking calls
        /// - Warning: Must create before using any public API
        public class Manager {
            public init(){}
            internal var session : NetworkSession = URLSession.shared
            
            public func loadData(from url: URL, completionHandler: @escaping(NetworkResult<Data>)->Void){
                session.get(from: url){
                    data, error in
                    let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                    completionHandler(result)
                }
            }
           
            public func loadData<I: Codable>(to url: URL, body: I, completionHandler: @escaping(NetworkResult<Data>)-> Void){
                var request = URLRequest(url: url)
                do{
                    let httpBody = try JSONEncoder().encode(body)
                    request.httpBody = httpBody
                    request.httpMethod = "POST"
                    session.post(with: request){data, error in
                        let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                        completionHandler(result)
                    }
                }catch let error {
                    return completionHandler(.failure(error))
                }
            }
            
        }
        
        public enum NetworkResult<Value>{
            case success(Value)
            case failure(Error?)
        }
    }
}
