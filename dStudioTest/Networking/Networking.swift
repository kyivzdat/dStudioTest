//
//  Networking.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 29.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

class Networking {
    
    private var requestPerformer: RequestPerformerProtocol
    
    init(_ requestPerformer: RequestPerformerProtocol = RequestPerformer()) {
        self.requestPerformer = requestPerformer
    }
    
    func getClasses(completion: @escaping ([ClassModel]?) -> ()) {
        
        let httpRequest = "classes/all_classes"
        requestPerformer.perform(httpRequest: httpRequest,
                              completion: completion)
    }
}
