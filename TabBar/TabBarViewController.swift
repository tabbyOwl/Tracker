//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import UIKit

final class TabBarController: UITabBarController {
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setControllersToTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: -Private methods
    private func setupTabBar() {
        
    }
    
    private func setControllersToTabBar() {
        let trackersViewController = TrackersViewController()
       
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "circle.circle.fill"),
            selectedImage: nil
        )
        let navTrackersListViewController = UINavigationController(rootViewController: trackersViewController)
        
        let statisticsViewController = UIViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                     image: UIImage(systemName: "hare.fill"),
                                     selectedImage: nil)
        
        
        self.viewControllers = [navTrackersListViewController, statisticsViewController]
    }
}


