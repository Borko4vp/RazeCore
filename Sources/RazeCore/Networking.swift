//
//  RazeNetworking.swift
//  RazeCore
//
//  Created by Borko Tomic on 28/05/2020.
//

import Foundation

extension RazeCore {
    public struct Networking {
        
        /// Responsible for handling all networking calls
        /// - Warning:   Must create before using any public API
        public class Manager {
            public init() {
                
            }
            
            private let session = URLSession.shared
            
            public func loadData(from url: URL, completion: @escaping (NetworkResult<Data>) -> Void) {
                let task = session.dataTask(with: url) { data, response, error in
                    let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                    completion(result)
                }
                
                task.resume()
            }
        }
        
        public enum NetworkResult<Value> {
            case success(Value)
            case failure(Error?)
        }
    }
}
