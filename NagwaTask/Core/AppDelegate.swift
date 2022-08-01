//
//  AppDelegate.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 27/03/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let listFilesViewController = ListFilesRouter.createListFilesViewController(directory: nil)
        let navigationController = UINavigationController(rootViewController: listFilesViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

