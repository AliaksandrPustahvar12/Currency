//
//  NetWorkService.swift
//  Currency
//
//  Created by Aliaksandr Pustahvar on 27.06.23.
//

import SwiftUI
import Alamofire

class NetworkService {
    
    func getData(from url: URL) async throws -> CurrencyDto {
        try await AF.request(url).serializingDecodable(CurrencyDto.self).value
    }
}
