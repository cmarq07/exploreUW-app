//
//  ViewController.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 5/19/22.
//

import UIKit

class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabBar.unselectedItemTintColor = .red
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

