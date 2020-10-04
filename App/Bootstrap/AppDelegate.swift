//
//  AppDelegate.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Core
import Database
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var injector = Injector()
    let coreDataProvider = CoreDataProvider()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Injecting the app dependencies
        injector.load()
        return true
    }
}
