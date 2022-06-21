//
//  CustomTabBarController.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    private let doorsSection = DoorsViewController()
    private let camerasSection = CamerasViewController()
    
    private lazy var controllers: [UIViewController] = [
        UINavigationController(rootViewController: camerasSection),
        UINavigationController(rootViewController: doorsSection),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTabBarAppearance()
        setViewControllers(controllers, animated: false)
        setupTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        let height = navigationController?.navigationBar.frame.maxY
        tabBar.frame = CGRect(x: 0, y: height ?? 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height / 2)
        super.viewDidLayoutSubviews()
      }
}

//MARK: - Private Methods
extension CustomTabBarController {
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Мой дом"
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearance
    }
    
    private func setupTabBar() {
        let arrayOfTitles = [
            "Камеры",
            "Двери"
        ]
        for counter in 0..<controllers.count {
            controllers[counter].title = arrayOfTitles[counter]
        }
        tabBar.tintColor = .blue
        tabBar.backgroundColor = .systemBackground
    }
}
