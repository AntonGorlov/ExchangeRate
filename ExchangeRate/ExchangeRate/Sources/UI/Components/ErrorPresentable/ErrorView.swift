//
//  ErrorView.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import SwiftUI

struct ErrorView: View {
    let error: ExchangeRateError
    let action: () -> ()
    
    var body: some View {
        ContentUnavailableView {
        
            Label("Error", systemImage: "banknote")

        } description: {
            Text(error.localizedDescription)
        } actions: {
          
            Button("Try Again") {
                action()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

#Preview {
    ErrorView(error: .dataIsEmpty, action: {})
}
