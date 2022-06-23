//
//  CustomTabBarController.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    private let indicatorLineHeight: CGFloat = 1.5
    
    private let titleAttributes = [
        NSAttributedString.Key.font: UIFont(name: Assets.fontRegular.rawValue, size: 21)!,
        NSAttributedString.Key.foregroundColor: UIColor.textLabel,
    ]
    
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
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = titleAttributes
        appearance.largeTitleTextAttributes = titleAttributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .textLabel
        navigationItem.title = "Мой дом"
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -(tabBar.frame.size.height / 4))
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -(tabBar.frame.size.height / 4))
        tabBar.standardAppearance = appearance
        UITabBarItem.appearance().setTitleTextAttributes(titleAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(titleAttributes, for: .selected)
    }
    
    private func setupTabBar() {
        let arrayOfTitles = [
            "Камеры",
            "Двери"
        ]
        for counter in 0..<controllers.count {
            controllers[counter].title = arrayOfTitles[counter]
        }
        
        tabBar.tintColor = .customBlueColor
        tabBar.backgroundColor = .systemBackground
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(
            color: .customBlueColor,
            size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count),
                         height: (tabBar.frame.height - indicatorLineHeight)),
            lineHeight: indicatorLineHeight)
    }
}
