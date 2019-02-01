//
//  AppDelegate.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 14/12/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit
import CocoaLumberjack
import Crashlytics
import Fabric
import Firebase
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Init the Logger system
        if let logger = DDOSLogger.sharedInstance {
            DDLog.add(logger) // TTY = Xcode console
            logger.logFormatter = CocoaLumberjackCustomFormatter() // init my custom formatter
            // Init a file loger
            let fileLogger: DDFileLogger = DDFileLogger() // File Logger
            fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)  // 24 hours
            fileLogger.logFileManager.maximumNumberOfLogFiles = 7
            DDLog.add(fileLogger)
        }
        
        // Setup Keychain
        let keychain = Keychain(service: "me.jeoffrey.boilerplate")
            .label("jeoffrey.me (Boilerplate)")
            .synchronizable(true)
        
        // Setup Firebase
        FirebaseApp.configure()
        
        // Setup Crashlytics
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
        // Setup api Tokens in keychain
        let apptweakToken = ""
        if apptweakToken == "" && (keychain["apptweakToken"] == nil || keychain["apptweakToken"] == "") {
            fatalError("Error! You need to add a tweak token for this app worked")
        } else if apptweakToken != "" {
            keychain["apptweakToken"] = apptweakToken
        }
        if let token = keychain["apptweakToken"] { print("My app tweek token: \(token)") }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

