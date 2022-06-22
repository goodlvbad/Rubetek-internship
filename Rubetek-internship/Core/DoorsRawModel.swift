//
//  DoorsRawModel.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 20.06.2022.
//

import Foundation

struct DoorsRawModel: Codable {
    let name: String
    let snapshot: String?
    let room: String?
    let id: Int
    let favorites: Bool
}

struct DoorsResponseModel: Responsable {
    func fetchData(comletion: @escaping (Responsable?, Error?) -> Void) {
        
    }
    
    let success: Bool
    let data: [DoorsRawModel]
}
