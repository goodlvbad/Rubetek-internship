//
//  Service.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 20.06.2022.
//

import Foundation

//Api: http://cars.cprogroup.ru/api/rubetek/cameras/ - метод получение камер http://cars.cprogroup.ru/api/rubetek/doors/ - метод получение дверей

enum ServiceMethod: String {
    case none
    case doors
    case cameras
}

protocol ServiceProtocol: AnyObject {
    func fetchDoorsData(comletion: @escaping (Swift.Result<[DoorsRawModel], Error>) -> Void)
    func fetchCamerasData(comletion: @escaping (Swift.Result<[CameraRawModel], Error>) -> Void)
}

class Service {
    private let network = NetworkCore.shared
    private var method: ServiceMethod = .none
}

extension Service: ServiceProtocol {
    func fetchDoorsData(comletion: @escaping (Result<[DoorsRawModel], Error>) -> Void) {
        method = .doors
        network.request(metadata: method.rawValue) { (result: Result<DoorsResponseModel, NetworkError>) in
            switch result {
            case .success(let respones):
                print(respones.data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCamerasData(comletion: @escaping (Result<[CameraRawModel], Error>) -> Void) {
        method = .cameras
        network.request(metadata: method.rawValue) { (result: Result<CamerasResponseModel, NetworkError>) in
            switch result {
            case .success(let respones):
                print(respones.data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
