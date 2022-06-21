//
//  NetworkCore.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 20.06.2022.
//

import Foundation

protocol NetworkCoreProtocol {
    func request<Res: Responsable>(metadata: String, comletion: @escaping (Result<Res, NetworkError>) -> Void)
}

final class NetworkCore {
    static let shared: NetworkCoreProtocol = NetworkCore()
    
    private let urlString = "http://cars.cprogroup.ru/api/rubetek"
    private let jsonDecoder = JSONDecoder()
}

extension NetworkCore: NetworkCoreProtocol {
    func request<Res: Responsable>(metadata: String, comletion: @escaping (Result<Res, NetworkError>) -> Void) {
        let urlRequest = URL(string: "\(urlString)/\(metadata)")

        guard let url = urlRequest else {
            comletion(.failure(NetworkError.invalidURL))
            return
        }

        let dataTask = URLSession
            .shared
            .dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data,
                   (response as? HTTPURLResponse)?.statusCode == 200,
                   error == nil {
                    self.handleSuccsesDataResponse(data, comletion: comletion)
                }
            })
        dataTask.resume()
    }
}

extension NetworkCore {
    private func handleSuccsesDataResponse<Res: Responsable>(_ data: Data, comletion: (Result<Res, NetworkError>) -> Void) {
        do {
            comletion(.success(try decodeData(data: data)))
        } catch {
            comletion(.failure(.responseDecodingError))
        }
    }
    
    private func decodeData<Res: Responsable>(data: Data) throws -> Res {
        let response = try jsonDecoder.decode(Res.self, from: data)
        return response
    }
}
