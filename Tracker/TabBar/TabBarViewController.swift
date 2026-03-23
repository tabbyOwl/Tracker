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
        setAppearance()
    }
    
    //MARK: -Private methods
    private func setControllersToTabBar() {
        let trackersViewController = TrackersViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: L10n.TabBar.trackersTitle,
            image: UIImage(systemName: "circle.circle.fill"),
            selectedImage: nil
        )
        let navTrackersListViewController = UINavigationController(rootViewController: trackersViewController)
        
        let statisticsViewController = StatisticsViewController()
        
        statisticsViewController.tabBarItem = UITabBarItem(title: L10n.TabBar.statisticsTitle,
                                                           image: UIImage(systemName: "hare.fill"),
                                                           selectedImage: nil)
        
        self.viewControllers = [navTrackersListViewController, statisticsViewController]
    }
    
    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.stackedLayoutAppearance.selected.iconColor = .projectColor(.blue)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.projectColor(.blue)
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = .projectColor(.gray)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.projectColor(.gray)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}


