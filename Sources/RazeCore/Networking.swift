//
//  RazeNetworking.swift
//  RazeCore
//
//  Created by Borko Tomic on 28/05/2020.
//

import Foundation

protocol NetworkSession {
    func get(from url: URL, completion: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
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
            ///   - completion: completion to execute after data is fetched
            public func loadData(from url: URL, completion: @escaping (NetworkResult<Data>) -> Void) {
                session?.get(from: url) { data, error in
                    let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                    completion(result)
                }
            }
        }
        
        public enum NetworkResult<Value> {
            case success(Value)
            case failure(Error?)
        }
    }
}
