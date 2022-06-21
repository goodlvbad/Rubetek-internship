//
//  DoorsViewController.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import UIKit

final class DoorsViewController: UIViewController {
    
    private let cellId = "doorsCellId"
    private let cellWithCameraId = "doorsCellWithCameraId"
    
    private lazy var customView = DoorsView()
    
    var flag = false
    
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupTableView()
    }
}

//MARK: - Private Methods
extension DoorsViewController {
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
        customView.tableView.register(DoorsTableCell.self, forCellReuseIdentifier: cellId)
        customView.tableView.register(DoorsWithCameraTableCell.self, forCellReuseIdentifier: cellWithCameraId)
    }
}

extension DoorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DoorsTableCell
        let cellWithCamera = tableView.dequeueReusableCell(withIdentifier: cellWithCameraId, for: indexPath) as! DoorsWithCameraTableCell
        if !flag {
            cell.callbackForLockBtn = changeFlag
            cell.setupCell(name: "test")
            return cell
        } else {
            cellWithCamera.callbackForLockBtn = changeFlag
            cellWithCamera.setupCell(image: nil, name: "nil")
            return cellWithCamera
        }
    }
    
    func changeFlag() {
        flag = !flag
        customView.tableView.reloadData()
    }
}
