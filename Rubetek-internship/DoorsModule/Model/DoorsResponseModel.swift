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
                comletion(respones, nil)
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
    func fetchDataFromRealm() throws -> Results<DoorsResponseModel> {
        let realm = try Realm()
        return realm.objects(DoorsResponseModel.self)
    }
    
    func saveData(data: DoorsResponseModel) {
        do {
            let realm = try Realm()
            do {
                try realm.write({
                    realm.add(data)
                })
            }
        } catch {
            print(error)
        }
    }

    func deleteData(data: Results<DoorsResponseModel>, comletion: @escaping (_ result: Bool, _ error: Error?) -> Void) {
        do {
            let realm = try Realm()
            do {
                try realm.write({
                    realm.delete(data)
                    comletion(true, nil)
                })
            }
        } catch {
            print(error)
            comletion(false, error)
        }
    }
    
    func changeName(data: Doors?, newName: String?) {
        do {
            let realm = try Realm()
            if let data = data {
                if let newName = newName,
                    !newName.isEmpty {
                    do {
                        try realm.write({
                            data.name = newName
                        })
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func addToFavorites(data: Doors?, isFavorite: Bool) {
        do {
            let realm = try Realm()
            if let data = data {
                do {
                    try realm.write({
                        data.favorites = isFavorite
                    })
                }
            }
        } catch {
            print(error)
        }
    }
}
