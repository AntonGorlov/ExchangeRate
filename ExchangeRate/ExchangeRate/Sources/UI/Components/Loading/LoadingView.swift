//
//  LoadingView.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .controlSize(.large)
    }
}

#Preview {
    LoadingView()
}
