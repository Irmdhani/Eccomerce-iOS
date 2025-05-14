//
//  ContentView.swift
//  fashionapi
//
//  Created by Ilham Ramadhani on 30/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return viewModel.products
        } else {
            return viewModel.products.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isSearching {
                    // Search bar shown only when search is active
                    HStack {
                        TextField("Search products...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            // Clear and hide search bar
                            searchText = ""
                            isSearching = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
                
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(filteredProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                VStack(spacing: 0) {
                                    WebImage(url: URL(string: product.thumbnail))
                                        .resizable()
                                        .indicator(.activity)
                                        .scaledToFit()
                                        .frame(height: 120)
                                    
                                    VStack(spacing: 4) {
                                        Text(product.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        HStack {
                                            Text("Price: $\(product.price)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            
                                            Spacer()
                                            
                                            Text("\(product.stock) Sold")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                }
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                }
            }
            .navigationBarTitle("Toko Palugada")
            .navigationBarItems(
                trailing:
                    HStack {
                        Button(action: {
                            withAnimation {
                                isSearching = true
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                        }

                        Button(action: {
                            print("Cart Pressed")
                        }) {
                            Image(systemName: "cart")
                        }
                    }
            )
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }
}
