//
//  RequestService.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 30.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

protocol RequestServiceProtocol {
    func makeRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (T?) -> ())
}

class RequestService: RequestServiceProtocol {
    
    func makeRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (T?) -> ()) {
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            
            DispatchQueue.main.async {
                guard let data = data else { completion(nil); return }
                
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    
                    completion(response)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }.resume()
    }
}
