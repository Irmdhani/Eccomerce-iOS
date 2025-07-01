//
//  ProductDetailView.swift
//  fashionapi
//
//  Created by Ilham Ramadhani on 30/04/25.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    WebImage(url: URL(string: product.thumbnail))
                        .resizable()
                        .indicator(.activity)
                        .scaledToFit()
                        .frame(height: 200)
                    
                    Text(product.title)
                        .font(.title)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("Price: $ \(String(format: "%.2f", product.price))")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Button(action: {
                            print("Favorited: \(product.title)")
                        }) {
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                        }
                    }
                    
                  Text("Rating: \(String(format: "%.1f", product.rating)) / 5 ⭐️")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    
                    Divider()
                    
                    Text("Description")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(product.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    HStack {
                        Text("Brand:")
                            .fontWeight(.semibold)
                        Text(product.brand)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("Category:")
                            .fontWeight(.semibold)
                        Text(product.category)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    Text("Customer Reviews")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(1..<4) { i in
                            Text("• Reviewer \(i): \"\(product.description.prefix(40))...\"")
                                .font(.caption)
                        }
                    }
                    
                }
                .padding(.bottom, 80)
                .padding()
            }
            VStack {
                Spacer()
                VStack {
                    Button(action: {
                        print("Added to cart: \(product.title)")
                    }) {
                        HStack {
                            Image(systemName: "cart.fill")
                                .font(.headline)
                            Text("Add to Cart")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.cyan)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                    }
                    .background(Color.cyan)
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .navigationTitle("Detail Product")
        }
    }
}

