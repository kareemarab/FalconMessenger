//
//  AppDelegate.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  
    let theme = ThemeManager.currentTheme()
    ThemeManager.applyTheme(theme: theme)
        
    FirebaseApp.configure()
    Database.database().isPersistenceEnabled = true
    
    let mainController = GeneralTabBarController()
    setTabs(mainController: mainController)
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = mainController
    window?.makeKeyAndVisible()
    window?.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
  
    userDefaults.configureInitialLaunch()
    presentOnboardingController(above: mainController)
    
    return true
  }
  
  func presentOnboardingController(above controller: UITabBarController) {
    guard Auth.auth().currentUser == nil else { return }
    let destination = OnboardingController()
    let newNavigationController = UINavigationController(rootViewController: destination)
    newNavigationController.navigationBar.shadowImage = UIImage()
    newNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    newNavigationController.modalTransitionStyle = .crossDissolve
    controller.present(newNavigationController, animated: false, completion: nil)
  }
  
  let chatsController = ChatsTableViewController()
  let contactsController = ContactsController()
  let settingsController = AccountSettingsController()
  
  func setTabs(mainController: UITabBarController) {

    contactsController.title = "Contacts"
    chatsController.title = "Chats"
    settingsController.title = "Settings"
    chatsController.delegate = mainController as? ManageAppearance
    
    let contactsNavigationController = UINavigationController(rootViewController: contactsController)
    let chatsNavigationController = UINavigationController(rootViewController: chatsController)
    let settingsNavigationController = UINavigationController(rootViewController: settingsController)

    if #available(iOS 11.0, *) {
      settingsNavigationController.navigationBar.prefersLargeTitles = true
      chatsNavigationController.navigationBar.prefersLargeTitles = true
      contactsNavigationController.navigationBar.prefersLargeTitles = true
    }
    
    let contactsImage =  UIImage(named: "user")
    let chatsImage = UIImage(named: "chat")
    let settingsImage = UIImage(named: "settings")

    let contactsTabItem = UITabBarItem(title: contactsController.title, image: contactsImage, selectedImage: nil)
    let chatsTabItem = UITabBarItem(title: chatsController.title, image: chatsImage, selectedImage: nil)
    let settingsTabItem = UITabBarItem(title: settingsController.title, image: settingsImage, selectedImage: nil)

    contactsController.tabBarItem = contactsTabItem
    chatsController.tabBarItem = chatsTabItem
    settingsController.tabBarItem = settingsTabItem
    
    let tabBarControllers = [contactsNavigationController, chatsNavigationController as UIViewController, settingsNavigationController]
    mainController.setViewControllers((tabBarControllers), animated: false)
    mainController.selectedIndex = tabs.chats.rawValue
  }
  
  var orientationLock = UIInterfaceOrientationMask.allButUpsideDown
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    guard Auth.auth().currentUser != nil else { return .portrait }
    return self.orientationLock
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
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}
