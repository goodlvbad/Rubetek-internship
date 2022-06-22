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
                self.saveData(data: respones)
                comletion(respones, nil)
            case .failure(let error):
                comletion(nil, error)
            }
        }
    }
    
    func saveData(data: CamerasResponseModel) {
        do {
            let realm = try Realm()
            do {
                try realm.write({
                    realm.add(data)
                    print("saved")
                })
            } catch (let errorRealm) {
                print(errorRealm.localizedDescription)
            }
        } catch {
            print(error)
        }
    }
    
    
}
