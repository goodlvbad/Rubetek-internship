//
//  Responsable.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 20.06.2022.
//

import Foundation

protocol Responsable: Codable {
    func fetchData(comletion: @escaping (_ result: Responsable?, _ error: Error?) -> Void)
}
