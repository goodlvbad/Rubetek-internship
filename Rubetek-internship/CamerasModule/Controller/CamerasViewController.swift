//
//  CamerasViewController.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import UIKit
import RealmSwift

final class CamerasViewController: UIViewController {
    
    private let cellId = "camerasCellId"
    private let headerId = "camerasHeaderId"
    
    private lazy var customView = CamerasView()

    private lazy var realm : Realm = {
        return try! Realm()
    }()
    
    private lazy var camerasObj = { realm.objects(CamerasResponseModel.self) }()
    private lazy var cameraModel = CamerasResponseModel()
    
    private lazy var cameras: [[(String?, String?, String?)]] = []
    
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupTableView()

        if camerasObj.isEmpty {
            cameraModel.fetchData { [weak self] result, error in
                guard let self = self else { return }
                if let result: CamerasResponseModel = result as? CamerasResponseModel {
                    self.prepareToShowData(result)
                }
                if let error = error {
                    print(error)
                }
            }
        } else {
            if let obj = camerasObj.first {
                self.prepareToShowData(obj)
            }
        }
    }
}

//MARK: - Private Methods
extension CamerasViewController {
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.tableView.register(CamerasTableCell.self, forCellReuseIdentifier: cellId)
        customView.tableView.register(CamerasSectionView.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    private func prepareToShowData(_ result: CamerasResponseModel) {
        for roomName in result.data.room {
            var tempArr: [(String?, String?, String?)] = []
            for camera in result.data.cameras {
                let cameraName = camera.name
                let cameraRoomName = camera.room
                let imageStr = camera.snapshot
                let cameraData = (cameraRoomName, cameraName, imageStr)
                if cameraRoomName?.lowercased() == roomName.lowercased() {
                    tempArr.append(cameraData)
                }
            }
            cameras.append(tempArr)
        }
        DispatchQueue.main.async {
            self.customView.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CamerasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cameras[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        cameras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CamerasTableCell
        let model = cameras[indexPath.section][indexPath.row]
        if let imageStr = model.2 {
            ImageLoader.shared.loadImage(from: imageStr) { image in
                cell.setupCell(image: image, name: model.1)
            }
        } else {
            cell.setupCell(image: nil, name: model.1)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CamerasSectionView
        let sectionName = cameras[section].first?.0
        header.setupHeader(title: sectionName)
        return header
    }

}
