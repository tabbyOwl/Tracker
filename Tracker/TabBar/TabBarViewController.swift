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
        tabBar.backgroundColor = .appBlack
        setControllersToTabBar()
        setAppearance()
    }
    
    //MARK: -Private methods
    private func setControllersToTabBar() {
        let trackersViewController = TrackersViewController(viewModel: TrackersViewModel())
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: L10n.TabBar.trackersTitle,
            image: SystemImage.circleCircleFill,
            selectedImage: nil
        )
        let navTrackersListViewController = UINavigationController(rootViewController: trackersViewController)
        
        let statisticsViewController = StatisticsViewController(viewModel: StatisticsViewModel())
        
        statisticsViewController.tabBarItem = UITabBarItem(title: L10n.TabBar.statisticsTitle,
                                                           image: SystemImage.hareFill,
                                                           selectedImage: nil)
        
        self.viewControllers = [navTrackersListViewController, statisticsViewController]
    }
    
    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .appWhite

        appearance.stackedLayoutAppearance.selected.iconColor = .appBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.appBlue
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = .appGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.appGray
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}


