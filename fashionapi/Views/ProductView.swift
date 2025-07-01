//
//  ProductView.swift
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
    
    var body: some View {
        NavigationView {
            // Gunakan Switch untuk menampilkan UI berdasarkan status dari ViewModel
            switch viewModel.viewState {
                
            // KASUS 1: SAAT STATUS.loading
            // Di sinilah Anda akan mengambil screenshot untuk laporan.
            case.loading:
                VStack(spacing: 10) {
                    ProgressView() // Ini adalah spinner yang berputar
                       .scaleEffect(1.5)
                    Text("Memuat Produk...")
                       .foregroundColor(.secondary)
                }
               .navigationTitle("Toko Palugada")

            // KASUS 2: SAAT STATUS.success
            // Tampilkan UI utama Anda jika data berhasil didapat.
            case.success(let products):
                // Logika filter yang sebelumnya Anda miliki, kita letakkan di sini
                let filteredProducts: [Product] = {
                    if searchText.isEmpty {
                        return products
                    } else {
                        return products.filter {
                            $0.title.localizedCaseInsensitiveContains(searchText)
                        }
                    }
                }()
                
                // Ini adalah seluruh VStack dari kode Anda sebelumnya
                VStack {
                    if isSearching {
                        HStack {
                            TextField("Search products...", text: $searchText)
                               .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
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
                                            
                                            HStack {
                                                Text("Price: $ \(String(format: "%.2f", product.price))")
                                                   .font(.subheadline)
                                                   .foregroundColor(.gray)
                                                   .lineLimit(2)
                                                
                                                Spacer()
                                                
                                                Text("\(product.stock) Sold")
                                                   .font(.subheadline)
                                                   .foregroundColor(.gray)
                                            }
                                        }
                                       .padding()
                                       .frame(maxWidth:.infinity)
                                       .background(Color.white)
                                    }
                                   .cornerRadius(10)
                                   .shadow(color:.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                               .frame(maxWidth:.infinity)
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

            // KASUS 3: SAAT STATUS.failure
            // Tampilkan pesan error jika terjadi kegagalan.
            case.failure(let error):
                VStack(spacing: 10) {
                    Image(systemName: "wifi.exclamationmark")
                       .font(.largeTitle)
                       .foregroundColor(.red)
                    Text("Gagal Memuat Data")
                       .font(.headline)
                    Text(error.localizedDescription)
                       .font(.caption)
                       .multilineTextAlignment(.center)
                       .padding(.horizontal)
                    Button("Coba Lagi") {
                        viewModel.fetchProducts()
                    }
                   .padding(.top)
                }
               .navigationTitle("Terjadi Kesalahan")

            // KASUS 4: SAAT STATUS.empty
            // Tampilkan pesan ini jika tidak ada data.
            case.empty:
                VStack(spacing: 10) {
                    Image(systemName: "tray.fill")
                       .font(.largeTitle)
                       .foregroundColor(.secondary)
                    Text("Tidak Ada Produk")
                       .font(.headline)
                    Text("Saat ini belum ada produk yang tersedia.")
                       .foregroundColor(.secondary)
                }
               .navigationTitle("Toko Palugada")
            }
        }
       .onAppear {
            // Hanya panggil fetchProducts jika viewState masih dalam kondisi awal (.empty)
            // untuk mencegah pemanggilan berulang saat kembali dari halaman detail.
            if case.empty = viewModel.viewState {
                viewModel.fetchProducts()
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
