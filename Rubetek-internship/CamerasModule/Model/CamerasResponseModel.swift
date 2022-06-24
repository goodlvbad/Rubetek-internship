//
//  CamerasResponseModel.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 22.06.2022.
//

import Foundation
import RealmSwift

class Cameras: Object, Codable {
    @objc dynamic var name: String = ""
    @objc dynamic var snapshot: String = ""
    @objc dynamic var room: String? = nil
    @objc dynamic var id: Int = 0
    @objc dynamic var favorites: Bool = false
    @objc dynamic var rec: Bool = false
}

class CamerasRoomDataObject: Object, Codable {
    var room = List<String>()
    var cameras = List<Cameras>()
}

class CamerasResponseModel: Object, Responsable {
    @objc dynamic var success: Bool = false
    @objc dynamic var data: CamerasRoomDataObject!
    
    func fetchData(comletion: @escaping (_ result: Responsable?, _ error: Error?) -> Void) {
        NetworkCore.shared.request(metadata: "cameras") { (result: Result<CamerasResponseModel, NetworkError>) in
            switch result {
            case .success(let respones):
                comletion(respones, nil)
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
    func fetchDataFromRealm() throws -> Results<CamerasResponseModel> {
        let realm = try Realm()
        return realm.objects(CamerasResponseModel.self)
    }
    
    func saveData(data: CamerasResponseModel) {
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
    
    func deleteData(data: Results<CamerasResponseModel>, comletion: @escaping (_ result: Bool, _ error: Error?) -> Void) {
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
    
    func addToFavorites(data: Cameras?, isFavorite: Bool, comletion: @escaping (_ result: Bool, _ error: Error?) -> Void) {
        do {
            let realm = try Realm()
            if let data = data {
                do {
                    try realm.write({
                        data.favorites = isFavorite
                        comletion(true, nil)
                    })
                }
            }
        } catch {
            print(error)
            comletion(false, error)
        }
    }
    
}
