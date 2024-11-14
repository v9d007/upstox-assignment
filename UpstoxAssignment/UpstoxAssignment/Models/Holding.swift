//
//  Holding.swift
//  Upstox-Assignment
//
//  Created by Vinod Kumar Singh on 09/11/24.
//

import Foundation

struct Root: Decodable {
    let data: Data
}

struct Data: Decodable {
    let userHolding: [Holding]
}

struct Holding: Decodable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}

