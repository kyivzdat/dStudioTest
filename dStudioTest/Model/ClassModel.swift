//
//  ClassModel.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 29.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import Foundation

// MARK: - ClassModel
struct ClassModel: Codable {
    let id: Int
    let name: String
    let type: String
    let prices: [Price]
    let teacher: Teacher?
    let levelOfDifficulty: Int
    let info: String
    let classPhotos: [ClassPhoto]
    let studio: Studio
    let maxUsersCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, type, prices, teacher
        case levelOfDifficulty = "level_of_difficulty"
        case info
        case classPhotos = "class_photos"
        case studio
        case maxUsersCount = "max_users_count"
    }
}

// MARK: - ClassPhoto
struct ClassPhoto: Codable {
    let id: Int
    let image: String
}

// MARK: - Price
struct Price: Codable {
    let id: Int
    let name: String
    let count, price, expirationDays: Int

    enum CodingKeys: String, CodingKey {
        case id, name, count, price
        case expirationDays = "expiration_days"
    }
}

// MARK: - Studio
struct Studio: Codable {
    let id: Int
    let name: String
}

// MARK: - Teacher
struct Teacher: Codable {
    let id: Int
    let name: String
    let phoneNumber: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case phoneNumber = "phone_number"
        case email
    }
}
