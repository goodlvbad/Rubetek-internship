//
//  ViewController.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 20.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setTitle("check network core", for: .normal)
        btn.addTarget(self, action: #selector(checkNetworkCore), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var flag = true
    
    private lazy var networkService: ServiceProtocol = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        view.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btn.heightAnchor.constraint(equalToConstant: 60),
        ])
        
    }

    @objc
    private func checkNetworkCore() {
        if flag {
            networkService.fetchCamerasData { result, error in
                if let result = result {
                   let urlImg = result[0].snapshot
                    print(urlImg)
                }
            }
        } else {
            networkService.fetchDoorsData { result, error in
                if let result = result {
                    let id = result[0].id
                    print(id)
                }
            }
        }
        flag = !flag
    }

}

