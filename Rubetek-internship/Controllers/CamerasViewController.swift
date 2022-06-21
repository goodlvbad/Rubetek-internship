//
//  CamerasViewController.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import UIKit

final class CamerasViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
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
}

