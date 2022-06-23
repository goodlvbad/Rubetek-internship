//
//  DoorsViewController.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import UIKit
import RealmSwift

final class DoorsViewController: UIViewController {
    
    private let cellId = "doorsCellId"
    private let cellWithCameraId = "doorsCellWithCameraId"
    
    private lazy var customView = DoorsView()

    private lazy var realm : Realm = {
        return try! Realm()
    }()
    
    private lazy var doorsObj = { realm.objects(DoorsResponseModel.self) }()
    private lazy var doorsModel = DoorsResponseModel()
    
    private lazy var doors: [(String, UIImage?)] = [] {
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
extension DoorsViewController {
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
        customView.tableView.register(DoorsTableCell.self, forCellReuseIdentifier: cellId)
        customView.tableView.register(DoorsWithCameraTableCell.self, forCellReuseIdentifier: cellWithCameraId)
    }
    
    private func getData() {
        if doorsObj.isEmpty {
            doorsModel.fetchData { [weak self] result, error in
                guard let self = self else { return }
                if let result: DoorsResponseModel = result as? DoorsResponseModel {
                    self.prepareToShowData(result)
                }
                if let error = error {
                    print(error)
                }
            }
        } else {
            if let obj = doorsObj.first {
                self.prepareToShowData(obj)
            }
        }
    }
    
    private func prepareToShowData(_ result: DoorsResponseModel) {
        for data in result.data {
            if let imageStr = data.snapshot {
                ImageLoader.shared.loadImage(from: imageStr) { image in
                    self.doors.append((data.name, image))
                }
            } else {
                doors.append((data.name, nil))
            }
        }
    }
}

extension DoorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        doors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DoorsTableCell
        let cellWithCamera = tableView.dequeueReusableCell(withIdentifier: cellWithCameraId, for: indexPath) as! DoorsWithCameraTableCell
        let model = doors[indexPath.row]
        if model.1 == nil {
            cell.setupCell(name: model.0)
            return cell
        } else {
            cellWithCamera.setupCell(image: model.1, name: model.0)
            return cellWithCamera
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            
            completion(true)
        }
        editAction.image = UIImage(named: Assets.editBtn.rawValue)
        editAction.backgroundColor = .systemGroupedBackground
        
        let starAction = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            //TODO logic
            completion(true)
        }
        starAction.image = UIImage(named: Assets.starBtn.rawValue)
        starAction.backgroundColor = .systemGroupedBackground
        
        return UISwipeActionsConfiguration(actions: [starAction, editAction])
    }
    
}
