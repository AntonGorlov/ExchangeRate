//
//  TabBarView.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var viewModel: ExchangeViewModel
    
    init(viewModel: ExchangeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        TabView {
            
            FavoritesView(viewModel: viewModel)
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            CurrenciesView(viewModel: viewModel)
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Currencies")
                }
        }
        
    }
}

#Preview {
    
    TabBarView(viewModel: ExchangeViewModel(apiService: nil,
                                            storageService: StorageService()))
}
