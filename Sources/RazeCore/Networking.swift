//
//  RazeNetworking.swift
//  RazeCore
//
//  Created by Borko Tomic on 28/05/2020.
//

import Foundation

protocol NetworkSession {
    func get(from url: URL, completion: @escaping (Data?, Error?) -> Void)
    func post(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func post(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: request) { data, _, error in
            completion(data, error)
        }
        task.resume()
    }
    
    func get(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url) { data, _, error in
             completion(data, error)
         }
         task.resume()
    }
    
    
}

extension RazeCore {
    public struct Networking {
        
        /// Responsible for handling all networking calls
        /// - Warning:   Must create before using any public API
        public class Manager {
            public init() {}
            
            internal var session: NetworkSession? = URLSession.shared
            
            /// Calls the live internet to retrieve Data from specific localtion
            /// - Parameters:
            ///   - url: the location you wish to fetch data from
            ///   - completion: completion to execute after API response is received
            public func loadData(from url: URL, completion: @escaping (NetworkResult<Data>) -> Void) {
                session?.get(from: url) { data, error in
                    let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                    completion(result)
                }
            }
            
            /// Calls the live internet to send Data to specific localtion
            /// - Warning: Make sure the url in question can accept POST route
            /// - Parameters:
            ///   - url: the localtion you wish to send data to
            ///   - body: the object you wish to send over the network
            ///   - completion: completion to execute after API response is received
            public func sendData<T:Codable>(to url: URL, with body: T, completion: @escaping (NetworkResult<Data>) -> Void) {
                var request = URLRequest(url: url)
                do {
                    let httpBody = try JSONEncoder().encode(body)
                    request.httpBody = httpBody
                    request.httpMethod = "POST"
                    session?.post(with: request) { data, error in
                        let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                        completion(result)
                    }
                } catch let error {
                    return completion(.failure(error))
                }
            }
        }
        
        public enum NetworkResult<Value> {
            case success(Value)
            case failure(Error?)
        }
    }
}
