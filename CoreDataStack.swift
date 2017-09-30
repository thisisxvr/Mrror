//
//  CoreDataStack.swift
//  Mrror
//
//  Created by Xavier Francis on 26/09/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit
import CoreData
import Foundation

func createMainContext(completion: @escaping (NSPersistentContainer) -> Void) {
    let container = NSPersistentContainer(name: "UserDataModel")
    print(container.persistentStoreDescriptions.first?.url! as Any) // Get SQLite DB location on disk.
    
    // Asynchronous
    container.loadPersistentStores(completionHandler: {
        persistentStoreDescription, error in
        
        guard error == nil else { fatalError("Failed to load store: \(String(describing: error))") }
        
        DispatchQueue.main.async {
            completion(container)
        }
    })
}

//func getLoginViewController() -> LoginViewController {
//    // Get window's root VC: Navigation Controller
//    let navController = window?.rootViewController as! UINavigationController
//
//    // Get Login VC from NavController's subviews
//    //        _ = navController.viewControllers.count
//    let loginVC = navController.viewControllers[0]
//
//    return loginVC as! LoginViewController
//}
