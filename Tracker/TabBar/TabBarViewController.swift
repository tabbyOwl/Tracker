//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import UIKit

final class TabBarController: UITabBarController {
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllersToTabBar()
    }
    
    //MARK: -Private methods
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


