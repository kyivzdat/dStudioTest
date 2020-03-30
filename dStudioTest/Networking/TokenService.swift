//
//  TokenService.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 30.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

protocol TokenServiceProtocol {
    func getToken(completion: @escaping (String?) -> ())
}

class TokenService: TokenServiceProtocol {
    
    private var requestPerformer: RequestServiceProtocol
    
    init(_ requestPerformer: RequestServiceProtocol = RequestService()) {
        self.requestPerformer = requestPerformer
    }
    
    private func makeRequestForToken(completion: @escaping (TokenModel?) -> ()) {
        
        guard let url = URL(string: "http://kulture-heroku.herokuapp.com/authorization/login/") else { return }
        
        let body = ["password": "qQ12345678",
                    "phone_number": "+6500000003"]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        requestPerformer.makeRequest(request, completion: completion)
    }
    
    // MARK: - getToken
    func getToken(completion: @escaping (String?) -> ()) {
        
        let userDefaults = UserDefaults.standard
        if let token = userDefaults.string(forKey: "Token") {
            completion(token)
        } else {
            self.makeRequestForToken { (token) in
                guard let token = token?.key else {
                    completion(nil)
                    return
                }
                // Save token in memory
                userDefaults.set(token, forKey: "Token")
                completion(token)
            }
        }
    }
}
