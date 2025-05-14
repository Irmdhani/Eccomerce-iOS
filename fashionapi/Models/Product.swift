//
//  Product.swift
//  fashionapi
//
//  Created by Ilham Ramadhani on 30/04/25.
//

import Foundation

struct Product: Identifiable {
    let id: Int
    let title: String
    let price: Int
    let thumbnail: String
    let description: String
    let category: String
    let brand: String
    let rating: Double
    let stock: Int
}
