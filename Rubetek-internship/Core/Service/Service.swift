//
//  Service.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 20.06.2022.
//

import Foundation

enum ServiceMethod: String {
    case none
    case doors
    case cameras
}

protocol ServiceProtocol: AnyObject {
    func fetchDoorsData(comletion: @escaping (_ result: [DoorsRawModel]?, _ error: Error?) -> Void)
//    func fetchCamerasData(comletion: @escaping (_ result: DataRawModel?, _ error: Error?) -> Void)
}

class Service {
    private let network = NetworkCore.shared
    private var method: ServiceMethod = .none
}

extension Service: ServiceProtocol {
    func fetchDoorsData(comletion: @escaping (_ result: [DoorsRawModel]?, _ error: Error?) -> Void) {
        method = .doors
        network.request(metadata: method.rawValue) { (result: Result<DoorsResponseModel, NetworkError>) in
            switch result {
            case .success(let respones):
                comletion(respones.data, nil)
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
//    func fetchCamerasData(comletion: @escaping (_ result: DataRawModel?, _ error: Error?) -> Void) {
//        method = .cameras
//        network.request(metadata: method.rawValue) { (result: Result<CamerasResponseModel, NetworkError>) in
//            switch result {
//            case .success(let respones):
//                comletion(respones.data, nil)
//            case .failure(let error):
//                comletion(nil, error)
//            }
//        }
//    }
}
