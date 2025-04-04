//
//  FavoriteCurrencyCell.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 03.04.2025.
//

import SwiftUI

struct FavoriteCurrencyCell: View {
    let model: CurrencyModel
    
    @StateObject var viewModel: ExchangeViewModel
    
    var body: some View {
        HStack {
            
            Image(systemName: "banknote.fill")
                .font(.system(size: 36, weight: .medium))
                .foregroundColor(Color.blue)
            
            VStack(alignment: .leading) {
                
                Text(model.code)
                    .font(.headline)
                
                Text(model.name)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(model.rate)
                .foregroundStyle(.blue)
                .font(.body)
            
            Button(action: {
                withAnimation(.linear) {
                    viewModel.toggleFavorite(currencyCode: model.code)
                }
            }) {
                Image(systemName: viewModel.isFavorite(currencyCode: model.code) ? "star.fill" : "star")
                    .foregroundColor(viewModel.isFavorite(currencyCode: model.code) ? .yellow : .gray)
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

    let model = CurrencyModel(code: "uah",
                              name: "Ukrainian Hryvnia",
                              rate: "1.023")
    FavoriteCurrencyCell(model: model,
                        viewModel:
                            ExchangeViewModel(apiService: nil,
                                              storageService: StorageService()))
}
