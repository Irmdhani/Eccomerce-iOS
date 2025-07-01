//
//  APIService.swift
//  fashionapi
//
//  Created by Ilham Ramadhani on 30/04/25.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ViewState<T> {
    case loading
    case success(T)
    case failure(Error)
    case empty
}

class ProductViewModel: ObservableObject {
    // Ganti @Published var products dengan ini:
    @Published var viewState: ViewState<[Product]> = .empty // Mulai dengan status kosong

    func fetchProducts() {
        // 1. Saat fungsi dipanggil, langsung ubah status menjadi.loading
        // UI akan menampilkan spinner (ProgressView)
        self.viewState = .loading
        
        let url = "https://dummyjson.com/products"

        // Menambahkan jeda buatan 2 detik untuk simulasi
        DispatchQueue.main.asyncAfter(deadline:.now() + 2.0) {
            AF.request(url).responseData { response in
                switch response.result {
                case.success(let data):
                    do {
                        let json = try JSON(data: data)
                        if let productArray = json["products"].array {
                            let fetched = productArray.map {
                                Product(
                                    id: $0["id"].intValue,
                                    title: $0["title"].stringValue,
                                    price: $0["price"].doubleValue,
                                    thumbnail: $0["thumbnail"].stringValue,
                                    description: $0["description"].stringValue,
                                    category: $0["category"].stringValue,
                                    brand: $0["brand"].stringValue,
                                    rating: $0["rating"].doubleValue,
                                    stock: $0["stock"].intValue
                                )
                            }
                            
                            // 2. Setelah data berhasil didapat
                            if fetched.isEmpty {
                                // Jika data kosong, atur status ke.empty
                                self.viewState = .empty
                            } else {
                                // Jika ada data, atur status ke.success
                                self.viewState = .success(fetched)
                            }
                        }
                    } catch {
                        // Jika terjadi error saat parsing JSON
                        self.viewState = .failure(error)
                    }
                    
                case.failure(let error):
                    // 3. Jika request ke jaringan gagal, atur status ke.failure
                    print("Fetch error: \(error)")
                    self.viewState = .failure(error)
                }
            }
        }
    }
}
