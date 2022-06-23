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
    private lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    private lazy var doorsModel = DoorsResponseModel()
    
    private lazy var doorsObj = {
        try! doorsModel.fetchDataFromRealm()
    }()

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
        customView.tableView.refreshControl = refreshControl
    }
    
    private func getData() {
        if doorsObj.isEmpty {
            doorsModel.fetchData { [weak self] result, error in
                guard let self = self else { return }
                if let result: DoorsResponseModel = result as? DoorsResponseModel {
                    DispatchQueue.main.async {
                        self.doorsModel.saveData(data: result)
                    }
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
    
    private func showAlertForEditing(index: Int) {
        let modelObj = doorsObj.first?.data[index]
        let alert = UIAlertController(title: "Введите название", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.layer.cornerRadius = 12
            textField.font = UIFont(name: Assets.fontRegular.rawValue, size: 17)
            textField.textColor = .textLabelForCells
            textField.attributedPlaceholder = NSAttributedString(string: "Новое имя", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.textLabelForCells,
                NSAttributedString.Key.font: UIFont(name: Assets.fontRegular.rawValue, size: 17)!,
            ])
            textField.textAlignment = .center
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
                let textField = alert.textFields![0]
            self.doorsModel.changeName(data: modelObj, newName: textField.text)
            self.editAndUpdateUI(index: index, newName: textField.text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func editAndUpdateUI(index: Int, newName: String?) {
        if let newName = newName,
           !newName.isEmpty {
            doors[index].0 = newName
            DispatchQueue.main.async {
                self.customView.tableView.reloadData()
            }
        }
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        doorsModel.deleteData(data: doorsObj) { [weak self] result, error in
            guard let self = self else { return }
            if result {
                self.doors.removeAll()
                self.getData()
            }
        }
        sender.endRefreshing()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
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
        
        let editAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            self.showAlertForEditing(index: indexPath.row)
            completion(true)
        }
        editAction.image = UIImage(named: Assets.editBtn.rawValue)
        editAction.backgroundColor = .systemGroupedBackground
        
        let starAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            guard let self = self else { return }
            guard let isFavorite = self.doorsObj.first?.data[indexPath.row].favorites else { return }
            self.doorsModel.addToFavorites(data: self.doorsObj.first?.data[indexPath.row],
                                           isFavorite: !isFavorite)
            completion(true)
        }
        starAction.image = UIImage(named: Assets.starBtn.rawValue)
        starAction.backgroundColor = .systemGroupedBackground
        
        return UISwipeActionsConfiguration(actions: [starAction, editAction])
    }
}
