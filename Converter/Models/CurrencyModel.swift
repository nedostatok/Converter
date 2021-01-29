//
//  CurrencyModel.swift
//  Converter
//
//  Created by User on 25.01.2021.
//

import Foundation

// MARK: - Results
struct Currency {
    let id: String
}

struct Rate: Codable {
    let result: Double
}

