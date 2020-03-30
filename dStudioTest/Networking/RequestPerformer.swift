//
//  RequestPerformer.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 30.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

protocol RequestPerformerProtocol {
    func perform<T: Decodable>(httpRequest: String, completion: @escaping (T?) ->())
}

class RequestPerformer: RequestPerformerProtocol {
    
    private static var token: String?
    
    private var tokenService: TokenServiceProtocol
    private var requestService: RequestServiceProtocol
    
    private let domain = "http://kulture-heroku.herokuapp.com/"
    
    init(_ tokenService: TokenServiceProtocol = TokenService(),
         _ requestPerformer: RequestServiceProtocol = RequestService()) {
        
        self.tokenService = tokenService
        self.requestService = requestPerformer
    }
    
    // MARK: - perform
    func perform<T: Decodable>(httpRequest: String, completion: @escaping (T?) ->()) {
        
        let queue = DispatchQueue(label: "MyQueue", attributes: .concurrent)
        queue.async {
            
            if RequestPerformer.token == nil {
                self.tokenHandler()
            }
            
            guard
                let url = URL(string: self.domain + httpRequest),
                let token = RequestPerformer.token
                else { completion(nil); return }
            
            var request = URLRequest(url: url)
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
            
            self.requestService.makeRequest(request, completion: completion)
        }
    }
    
    private func tokenHandler() {
        let semaphore = DispatchSemaphore(value: 0)
        
        self.tokenService.getToken() { token in
            RequestPerformer.token = token
            semaphore.signal()
        }
        semaphore.wait()
    }
}
