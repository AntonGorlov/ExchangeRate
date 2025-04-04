//
//  ExchangeRateApp.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 01.04.2025.
//

import SwiftUI
import SwiftData
import BackendAPI

@main
struct ExchangeRateApp: App {

    var body: some Scene {
        WindowGroup {
          //  ContentView()
            let configuration = APIConfiguration()
            let apiController = ExchangeRateAPIController(configuration: configuration)
            let apiService = ExchangeRateService(apiController: apiController)
            let storageService = StorageService()
            let viewModel = ExchangeViewModel(apiService: apiService,
                                              storageService: storageService)
            TabBarView(viewModel: viewModel)
        }
    }
}
