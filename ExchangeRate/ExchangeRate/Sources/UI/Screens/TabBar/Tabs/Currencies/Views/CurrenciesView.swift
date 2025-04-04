//
//  CurrenciesView.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import SwiftUI

struct CurrenciesView: View {
    @StateObject var viewModel: ExchangeViewModel
    @State private var searchText = ""
    
    private var filteredCurrencies: [String] {
        viewModel.currenciesName.keys.sorted().filter {
            searchText.isEmpty ||
            $0.lowercased().contains(searchText.lowercased()) ||
            (viewModel.currenciesName[$0]?.lowercased().contains(searchText.lowercased()) ?? false)
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            context
                .navigationTitle("Available Currencies:")
                .searchable(text: $searchText, prompt: "Search currency")
        }
    }
    
    private var context: some View {
        
        Group {
            
            switch viewModel.stateOfCurrencies {
                
            case .loading:
                
                LoadingView()
            case .error(let exchangeRateError):
                
                ErrorView(error: exchangeRateError) {
                    Task {
                        await viewModel.getAvailableCurrencies()
                    }
                }
            case .empty:
                
                emptyStateView
            case .content:
                
                currenciesListView
            }
        }
        .animation(.spring, value: viewModel.stateOfCurrencies)
    }
    
    private var emptyStateView: some View {
        
        ContentUnavailableView("Тo currencies available",
                               systemImage: "banknote",
                               description: Text("Try again later"))
    }
    
    private var currenciesListView: some View {
        
        List {
            
            ForEach(filteredCurrencies, id: \.self) { currencyCode in
                
                CurrencyCell(code: currencyCode,
                             name: viewModel.currenciesName[currencyCode] ?? "",
                             viewModel: viewModel)
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.ultraThinMaterial)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                )
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    CurrenciesView(viewModel: ExchangeViewModel(apiService: nil,
                                                storageService: StorageService()))
}
