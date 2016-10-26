//
//  AppDelegate.swift
//  GoogleSheetDemo
//
//  Created by José María Ila on 25/10/16.
//  Copyright © 2016 Vector Mobile. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    var window: UIWindow?

    // MARK: - AppDelegate methods
    
    /**
     Tells the delegate that the launch process is almost done and the app is almost ready to run.
     
     - parameter application:   Your singleton app object.
     - parameter launchOptions: A dictionary indicating the reason the app was launched (if any).
     
     - returns: NO if the app cannot handle the URL resource or continue a user activity, otherwise return YES.
     */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let viewController = ViewController()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }

}

