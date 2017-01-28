//
//  AppDelegate.swift
//  Energyhack
//
//  Created by Alexey Potapov on 27/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit
import AeroGearPush
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    print("Something went wrong")
                }
            })
            
            PushAnalytics.sendMetricsWhenAppLaunched(launchOptions: launchOptions)
            
            // Display all push messages (even the message used to open the app)
            if let options = launchOptions {
                if let option : NSDictionary = options[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                    let defaults: UserDefaults = UserDefaults.standard
                    // Send a message received signal to display the notification in the table.
                    if let aps : NSDictionary = option["aps"] as? NSDictionary {
                        if let alert = aps["alert"] as? String {
                            defaults.set(alert, forKey: "message_received")
                            defaults.synchronize()
                        } else {
                            let alert = aps["alert"] as! [String : AnyObject]
                            let msg = alert["body"] as! String
                            defaults.set(msg, forKey: "message_received")
                            defaults.synchronize()
                        }
                    }
                }
            }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        
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

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // time to register user with the "AeroGear UnifiedPush Server"
        let device = DeviceRegistration(config: "pushconfig")
        // perform registration of this device
        device.register(clientInfo:{clientInfo in
            
            // set the deviceToken
            clientInfo.deviceToken = deviceToken
            
            // --optional config--
            // set some 'useful' hardware information params
            let currentDevice = UIDevice()
            
            clientInfo.operatingSystem = currentDevice.systemName
            clientInfo.osVersion = currentDevice.systemVersion
            clientInfo.deviceType = currentDevice.model
        },
                                      
          success: {
            // successfully registered!
            print("successfully registered with UPS!")
            
            // send NSNotification for success_registered, will be handle by registered AGViewController
            let notification = Notification(name:Notification.Name(rawValue: "success_registered"), object: nil)
            NotificationCenter.default.post(notification)
        },
                                      
          failure: {(error: NSError!) in
            print("Error Registering with UPS: \(error.localizedDescription)")
            
            let notification = Notification(name:Notification.Name(rawValue: "error_register"), object: nil)
            NotificationCenter.default.post(notification)
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let notification = Notification(name:Notification.Name(rawValue: "error_register"), object:nil, userInfo:nil)
        NotificationCenter.default.post(notification)
        print("Unified Push registration Error \(error)")
    }

    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // When a message is received, send NSNotification, would be handled by registered ViewController
        let notification = Notification(name:Notification.Name(rawValue:"message_received"), object:nil, userInfo:userInfo)
        NotificationCenter.default.post(notification)
        print("UPS message received: \(userInfo)")
        
        // Send metrics when app is launched due to push notification
        PushAnalytics.sendMetricsWhenAppAwoken(applicationState: application.applicationState, userInfo: userInfo)
        
        // No additioanl data to fetch
        fetchCompletionHandler(UIBackgroundFetchResult.noData)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("1")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("2")
    }
}

