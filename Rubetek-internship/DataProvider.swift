//
//  DataProvider.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import Foundation
import RealmSwift

protocol DataProviderProtocol {
    func saveCamerasData(data: DataRawModel)
    func fetchCameraData() -> [CamerasRoomData]
    func prepareToShowCameraData(from data: DataRawModel) -> [CamerasRoomData]
    
    func removeAll()
}

final class DataProvider: DataProviderProtocol {
    static let shared: DataProviderProtocol = DataProvider()
    
    private lazy var loadingQueue = DispatchQueue(label: "loading queue")
    
    private lazy var realm : Realm = {
        return try! Realm()
    }()
    
    private let userData = UserData()
    
    func removeAll() {
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        try! FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        userData.setSavedCamersData(false)
    }
}

class Doors: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var snapshot: String? = nil
    @objc dynamic var room: String? = nil
    @objc dynamic var id: Int = 0
    @objc dynamic var favorites: Bool = false
}

class Cameras: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var snapshot: String = ""
    @objc dynamic var room: CamerasRoomDataObject!
    @objc dynamic var id: Int = 0
    @objc dynamic var favorites: Bool = false
    @objc dynamic var rec: Bool = false
}

class CamerasRoomDataObject: Object {
    @objc dynamic var name: String = ""
    let cameras = List<Cameras>()
}


//MARK: - Cameras Data
extension DataProvider {
    
    func saveCamerasData(data: DataRawModel) {
        for room in data.room {
            let roomData = CamerasRoomDataObject()
            roomData.name = room
            for raw in data.cameras {
                let camera = Cameras()
                camera.name = raw.name
                camera.snapshot = raw.snapshot
                camera.id = raw.id
                camera.rec = raw.rec
                if raw.room?.lowercased() == roomData.name.lowercased() {
                    camera.room = roomData
                    roomData.cameras.append(camera)
                }
                loadingQueue.async { [weak self] in
                    guard let self = self else { return }
                    self.realm.beginWrite()
                    self.realm.add(camera)
                    do {
                        try self.realm.commitWrite()
                    } catch {
                        print("error saving camera")
                    }
                }
            }
            loadingQueue.async { [weak self] in
                guard let self = self else { return }
                self.realm.beginWrite()
                self.realm.add(roomData)
                do {
                    try self.realm.commitWrite()
                    self.userData.setSavedCamersData(true)
                } catch {
                    print("error saving room data")
                }
            }
        }
    }
    
    func fetchCameraData() -> [CamerasRoomData] {
        var tempArr: [CamerasRoomData] = []
        let rooms: Results<CamerasRoomDataObject> = realm.objects(CamerasRoomDataObject.self)
        for room in rooms {
            var tempArrModel: [CameraRawModel] = []
            let roomName = room.name
            for camera in room.cameras {
                let cameraModel = CameraRawModel(name: camera.name,
                                                 snapshot: camera.snapshot,
                                                 room: camera.room.name,
                                                 id: camera.id,
                                                 favorites: camera.favorites,
                                                 rec: camera.rec)
                if roomName.lowercased() == cameraModel.room?.lowercased() {
                    tempArrModel.append(cameraModel)
                }
//                tempArrModel.append(cameraModel)
            }
            let data = CamerasRoomData(room: roomName, cameras: tempArrModel)
            tempArr.append(data)
        }
//        print(tempArr)
        return tempArr
    }
    
    func prepareToShowCameraData(from data: DataRawModel) -> [CamerasRoomData] {
        var tempArr: [CamerasRoomData] = []
        for room in data.room {
            var tempArrModel: [CameraRawModel] = []
            for camera in data.cameras {
                if room.lowercased() == camera.room?.lowercased() {
                    tempArrModel.append(camera)
                }
//                tempArrModel.append(camera)
            }
            let data = CamerasRoomData(room: room, cameras: tempArrModel)
            tempArr.append(data)
        }
        return tempArr
    }
}
