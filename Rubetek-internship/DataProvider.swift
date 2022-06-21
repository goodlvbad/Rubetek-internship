//
//  DataProvider.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import Foundation

protocol DataProviderProtocol {
    
}

final class DataProvider: DataProviderProtocol {
    static let shared: DataProviderProtocol = DataProvider()
    
}
