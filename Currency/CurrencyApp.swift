//
//  CurrencyApp.swift
//  Currency
//
//  Created by Aliaksandr Pustahvar on 27.06.23.
//

import SwiftUI

@main
struct CurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(fromAmount: "", toAmount: 0, result: "")
        }
    }
}
