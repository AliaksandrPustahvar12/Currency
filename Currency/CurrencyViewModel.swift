//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by Aliaksandr Pustahvar on 27.06.23.
//

import SwiftUI

final class CurrencyViewModel: ObservableObject {
    
    private let network = NetworkService()
    @Published var isError = false
    
    func getValutes() async -> [String] {
        var arrayValutes = [String]()
        let urlforValutes = "https://api.exchangerate.host/latest?"
        if let url = URL(string: urlforValutes) {
            if let data = try? await network.getData(from: url) {
                arrayValutes = data.rates.map {$0.key}.sorted { $0 < $1 }
                return arrayValutes
            }
        }
        return arrayValutes
    }
    
    func getResult(from: String, to: String, amount: Double) async -> Double? {
        var result: Double?
        let url = "https://api.exchangerate.host/latest?base=\(from)&amount=\(amount)"
        if let url = URL(string: url) {
            do {
                let data = try await network.getData(from: url)
                if let element = data.rates.first(where: { $0.key == to }){
                    result = element.value
                    return result
                } else {
                    await  MainActor.run {
                        isError = true
                    }
                }
            } catch {
                await  MainActor.run {
                    isError = true
                }
                print(error.localizedDescription)
                result = nil
            }
        }
        return result
    }
}
