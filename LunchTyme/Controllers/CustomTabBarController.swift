//
//  TabBarController.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK: -setup views
    func setup() {
        //set up VCs here
        let layout = UICollectionViewFlowLayout()
        let listVC = ListVC(collectionViewLayout: layout)
        let lunchNavController = UINavigationController(rootViewController: listVC)
        lunchNavController.navigationBar.titleTextAttributes = [.font: UIFont(name: "AvenirNext-DemiBold", size: 17)!, .foregroundColor: UIColor(red: 255, green: 255, blue: 255)]
        lunchNavController.tabBarItem.title = "lunch"
        lunchNavController.tabBarItem.image = UIImage(named: "tab_lunch")
        
        let webVC = InternetsVC()
        let navWeb = UINavigationController(rootViewController: webVC)
        navWeb.tabBarItem.title = "internets"
        navWeb.tabBarItem.image = UIImage(named: "tab_internets")
        
        viewControllers = [lunchNavController, navWeb]
    }
}

// MARK: -adjust tabbar height

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50 // adjust your size here
        return sizeThatFits
    }
}
