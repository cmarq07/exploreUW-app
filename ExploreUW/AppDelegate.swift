//
//  AppDelegate.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 5/19/22.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        let font = UIFont(name:"Encode Sans Normal", size: 14.0)
        let boldFont = UIFont(name:"Encode Sans Normal Bold", size: 14.0)

        let normalTextAttributes = [
            NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColorFromRGB(0xD2B476)
        ]

        let selectedTextAttributes = [
            NSAttributedString.Key.font: boldFont
        ]

        UITabBarItem.appearance().setTitleTextAttributes(normalTextAttributes as [NSAttributedString.Key : Any], for: .normal)

        UITabBarItem.appearance().setTitleTextAttributes(selectedTextAttributes as [NSAttributedString.Key : Any], for: .selected)

        UITabBarItem.appearance().badgeColor = UIColorFromRGB(0x85754D)

        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.titleTextAttributes = normalTextAttributes as [NSAttributedString.Key : Any]
        tabBarItemAppearance.selected.titleTextAttributes = selectedTextAttributes as [NSAttributedString.Key : Any]

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.inlineLayoutAppearance.normal.iconColor = UIColorFromRGB(0x85754D)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColorFromRGB(0x85754D)
        tabBarAppearance.compactInlineLayoutAppearance  .normal.iconColor = UIColorFromRGB(0x85754D)
        tabBarAppearance.inlineLayoutAppearance.normal.badgeBackgroundColor = UIColorFromRGB(0xD3AF43)
        tabBarAppearance.stackedLayoutAppearance.normal.badgeBackgroundColor = UIColorFromRGB(0xD3AF43)
        tabBarAppearance.compactInlineLayoutAppearance  .normal.badgeBackgroundColor = UIColorFromRGB(0xD3AF43)
        tabBarAppearance.stackedLayoutAppearance.normal.badgeTextAttributes = [
            NSAttributedString.Key.font: boldFont as Any, NSAttributedString.Key.foregroundColor: UIColor.black
        ]

        UITabBar.appearance().standardAppearance = tabBarAppearance

        return true
         
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func UIColorFromRGB(_ rgbValue: Int) -> UIColor! {
        return UIColor(
            red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0)
    }
}
