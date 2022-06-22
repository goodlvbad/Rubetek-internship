//
//  DoorsResponseModel.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 22.06.2022.
//

import Foundation
import RealmSwift

class Doors: Object, Codable {
    @objc dynamic var name: String = ""
    @objc dynamic var snapshot: String? = nil
    @objc dynamic var room: String? = nil
    @objc dynamic var id: Int = 0
    @objc dynamic var favorites: Bool = false
}

class DoorsResponseModel: Object, Responsable {
    @objc dynamic var success: Bool = false
    var data = List<Doors>()
    
    func fetchData(comletion: @escaping (_ result: Responsable?, _ error: Error?) -> Void) {
        NetworkCore.shared.request(metadata: "doors") { (result: Result<DoorsResponseModel, NetworkError>) in
            switch result {
            case .success(let respones):
                self.saveData(data: respones)
                comletion(respones, nil)
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
    func saveData(data: DoorsResponseModel) {
        do {
            let realm = try Realm()
            do {
                try realm.write({
                    realm.add(data)
                })
            } catch (let errorRealm) {
                print(errorRealm.localizedDescription)
            }
        } catch {
            print(error)
        }
    }
}
