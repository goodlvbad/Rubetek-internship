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
    
    private lazy var networkService: ServiceProtocol = Service()
    
    var camerasArr: [CameraRawModel] = []
    var roomsArr: [String] = []

    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupTableView()
        networkService.fetchCamerasData { result, error in
            if let result = result {
                self.camerasArr = result.cameras
                self.roomsArr = result.room
                DispatchQueue.main.async {
                    self.customView.tableView.reloadData()
                }
            }
            if let error = error {
                print(error.localizedDescription)
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
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CamerasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        camerasArr.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        roomsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CamerasTableCell
        let model = camerasArr[indexPath.row]
        cell.setupCell(image: nil, name: model.name)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CamerasSectionView
        let sectionName = roomsArr[section]
        header.setupHeader(title: sectionName)
        return header
    }
    
    
}