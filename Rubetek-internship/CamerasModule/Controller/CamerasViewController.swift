//
//  CamerasViewController.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import UIKit

final class CamerasViewController: UIViewController {
    
    private let cellId = "camerasCellId"
    private let headerId = "camerasHeaderId"
    
    private lazy var customView = CamerasView()
    private lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var cameraModel = CamerasResponseModel()
    private lazy var camerasObj = {
        try! cameraModel.fetchDataFromRealm()
    }()
    
    // 0 - roomName, 1 - cameraName, 2 - imageStr, 3 - rec, 4 - isFavorite
    private lazy var cameras: [[(String?, String?, String?, Bool, Bool)]] = [] {
        didSet {
            DispatchQueue.main.async {
                self.customView.tableView.reloadData()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupTableView()
        getData()
    }
}

//MARK: - Private Methods
extension CamerasViewController {
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.tableView.register(CamerasTableCell.self, forCellReuseIdentifier: cellId)
        customView.tableView.register(CamerasSectionView.self, forHeaderFooterViewReuseIdentifier: headerId)
        customView.tableView.refreshControl = refreshControl
    }
    
    private func getData() {
        if camerasObj.isEmpty {
            cameraModel.fetchData { [weak self] result, error in
                guard let self = self else { return }
                if let result: CamerasResponseModel = result as? CamerasResponseModel {
                    DispatchQueue.main.async {
                        self.cameraModel.saveData(data: result)
                    }
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
    
    private func prepareToShowData(_ result: CamerasResponseModel) {
        for roomName in result.data.room {
            var tempArr: [(String?, String?, String?, Bool, Bool)] = []
            for camera in result.data.cameras {
                let cameraName = camera.name
                let cameraRoomName = camera.room
                let imageStr = camera.snapshot
                let rec = camera.rec
                let isFavorite = camera.favorites
                let cameraData = (cameraRoomName, cameraName, imageStr, rec, isFavorite)
                if cameraRoomName?.lowercased() == roomName.lowercased() {
                    tempArr.append(cameraData)
                }
            }
            cameras.append(tempArr)
        }
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        cameraModel.deleteData(data: camerasObj) { [weak self] result, error in
            guard let self = self else { return }
            if result {
                self.cameras.removeAll()
                self.getData()
            }
        }
        sender.endRefreshing()
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
                cell.setupCell(image: image, name: model.1, rec: model.3, isFavorite: model.4)
            }
        } else {
            cell.setupCell(image: nil, name: model.1, rec: model.3, isFavorite: model.4)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CamerasSectionView
        let sectionName = cameras[section].first?.0
        header.setupHeader(title: sectionName)
        return header
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let starAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            guard let self = self else { return }
            guard let data = self.camerasObj.first?.data.cameras[indexPath.row] else { return }
            self.cameraModel.addToFavorites(data: data, isFavorite: !data.favorites) { result, error in
                self.cameras[indexPath.section][indexPath.row].4 = !data.favorites
            }
            completion(true)
        }
        starAction.image = UIImage(named: Assets.starBtn.rawValue)
        starAction.backgroundColor = .systemGroupedBackground
        return UISwipeActionsConfiguration(actions: [starAction])
    }
}
