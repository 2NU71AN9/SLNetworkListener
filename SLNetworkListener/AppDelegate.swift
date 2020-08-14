//
//  AppDelegate.swift
//  SLNetworkListener
//
//  Created by 孙梁 on 2020/8/14.
//  Copyright © 2020 孙梁. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SLNetworkListener.shared.listen()
        return true
    }
}

