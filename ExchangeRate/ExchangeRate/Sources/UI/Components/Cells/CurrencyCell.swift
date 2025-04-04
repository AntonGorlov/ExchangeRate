//
//  CurrencyRow.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import SwiftUI

struct CurrencyCell: View {
    let code: String
    let name: String
    @StateObject var viewModel: ExchangeViewModel
    
    var body: some View {
        HStack {
            
            Image(systemName: "banknote.fill")
                .font(.system(size: 36, weight: .medium))
                .foregroundColor(Color.blue)
            
            VStack(alignment: .leading) {
                
                Text(code)
                    .font(.headline)
                
                
                Text(name)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.linear) {
                    viewModel.toggleFavorite(currencyCode: code)
                }
            }) {
                Image(systemName: viewModel.isFavorite(currencyCode: code) ? "star.fill" : "star")
                    .foregroundColor(viewModel.isFavorite(currencyCode: code) ? .yellow : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            
        }
        .frame(height: 44)
        .contentShape(Rectangle())
        .padding(5)
    }
}

#Preview {
    CurrencyCell(code: "usd",
                 name: "US Dollar",
                 viewModel: ExchangeViewModel(apiService: nil,
                                              storageService: StorageService()))
}
