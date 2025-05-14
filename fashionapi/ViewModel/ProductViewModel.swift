//
//  APIService.swift
//  fashionapi
//
//  Created by Ilham Ramadhani on 30/04/25.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []

    func fetchProducts() {
        let url = "https://dummyjson.com/products"

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let json = try? JSON(data: data)
                if let productArray = json?["products"].array {
                    let fetched = productArray.map {
                        Product(
                            id: $0["id"].intValue,
                            title: $0["title"].stringValue,
                            price: $0["price"].intValue,
                            thumbnail: $0["thumbnail"].stringValue,
                            description: $0["description"].stringValue,
                            category: $0["category"].stringValue,
                            brand: $0["brand"].stringValue,
                            rating: $0["rating"].doubleValue,
                            stock: $0["stock"].intValue
                        )
                    }
                    DispatchQueue.main.async {
                        self.products = fetched
                    }
                }
            case .failure(let error):
                print("Fetch error: \(error)")
            }
        }
    }
}
