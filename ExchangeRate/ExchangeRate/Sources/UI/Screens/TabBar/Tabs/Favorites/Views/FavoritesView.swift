//
//  FavoritesView.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel: ExchangeViewModel
    
    var body: some View {
        
        NavigationView {
            
            context
                .navigationTitle("Favorites:")
        }
    }
    
    private var context: some View {
        
        Group {
            
            switch viewModel.stateOfFavorite {
                
            case .loading:
                
                LoadingView()
            case .error(let exchangeRateError):
                
                ErrorView(error: exchangeRateError) {
                    
                    Task {
                        
                        await viewModel.getExchangeRates()
                    }
                }
            case .empty:
                
                emptyStateView
                
            case .content:
                
                favoriteListView
            }
            
        }
        .animation(.bouncy, value: viewModel.stateOfFavorite)
    }
    
    private var favoriteListView: some View {
        
        List {
            
            if let baseCurrency = viewModel.favoriteList.first {
                
                Section(header: Text("Base currency:")) {
                    
                    cellFavorite(model: baseCurrency, viewModel: viewModel)
                }
            }
            
            let otherCurrencies = viewModel.favoriteList.dropFirst()
            if !otherCurrencies.isEmpty {
                
                Section(header: Text("Other currencies:")) {
                    
                    ForEach(otherCurrencies, id: \.self) { model in
                        
                        cellFavorite(model: model, viewModel: viewModel)
                    }
                }
            }
            
        }
        .listStyle(.inset)
    }
    
    private var emptyStateView: some View {
        
        ContentUnavailableView("No favorites",
                               systemImage: "banknote",
                               description: Text("You should add to favorites"))
    }
    
    private func cellFavorite(model: CurrencyModel,
                              viewModel: ExchangeViewModel) -> some View {
        
        FavoriteCurrencyCell(model: model, viewModel: viewModel)
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.ultraThinMaterial)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
            )
    }
}

#Preview {
    FavoritesView(viewModel: ExchangeViewModel(apiService: nil,
                                               storageService: StorageService()))
}
