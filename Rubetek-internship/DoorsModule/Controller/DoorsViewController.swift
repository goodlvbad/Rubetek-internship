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

    private lazy var networkService: ServiceProtocol = Service()
    
    var arr: [DoorsRawModel] = []
    
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupTableView()
        networkService.fetchDoorsData { result, error in
            if let result = result {
                self.arr = result
                
//                print(self.arr.count)
                
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
        arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DoorsTableCell
        let cellWithCamera = tableView.dequeueReusableCell(withIdentifier: cellWithCameraId, for: indexPath) as! DoorsWithCameraTableCell
        let model = arr[indexPath.row]
        if model.snapshot == nil {
            cell.setupCell(name: model.name)
            return cell
        } else {
            cellWithCamera.setupCell(image: nil, name: model.name)
            return cellWithCamera
        }
    }
    
}
