//
//  CurrencyModel.swift
//  Currency
//
//  Created by Aliaksandr Pustahvar on 27.06.23.
//

import SwiftUI

struct CurrencyDto: Decodable {
    
    var success: Bool
    let base: String
    let date: String
    let rates: [String: Double]
}
