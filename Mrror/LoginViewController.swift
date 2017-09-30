//
//  LoginViewController.swift
//  Mrror
//
//  Created by Xavier Francis on 23/09/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var usernameTxtBox: UITextField!
    @IBOutlet weak var passwordTxtBox: UITextField!
    
    @IBAction func loginBtnDidClick(_ sender: UIButton) {
        if authenticate() {
            let historyEntity = NSEntityDescription.insertNewObject(forEntityName: History.entityName, into: managedObjectContext) as! History
            let user = usernameTxtBox.text!
            
            historyEntity.user = user
            historyEntity.time = Date.init()
            
            // Create History entry.
            do {
                try managedObjectContext.save()
                
                // Debug.
                let historyReq = NSFetchRequest<History>(entityName: History.entityName)
                let history = try managedObjectContext.fetch(historyReq)
                print(history)
                
            } catch {
                print("Saving History entry went wrong: \(error)")
                managedObjectContext.rollback()
                return
            }
            
            // Let user know they've logged in.
            let alert = UIAlertController(title: "😃\nSuccesfully logged in", message: "", preferredStyle: .alert)
            let kay = UIAlertAction(title: "Cool", style: .default, handler: {
                _ in
                self.performSegue(withIdentifier: "unwindToCanvasSegue", sender: self)
            })
            alert.addAction(kay)
            present(alert, animated: true, completion: nil)
            
            // Segue back to Canvas.
        } else {
            let alert = UIAlertController(title: "😖\nWrong username", message: "and/or password.", preferredStyle: .alert)
            let kay = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(kay)
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func authenticate() -> Bool {
//        let userEntity = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: managedObjectContext) as! User
        let userReq = NSFetchRequest<User>(entityName: User.entityName)
        let user = usernameTxtBox.text!
        let pass = passwordTxtBox.text!
        
        do {
            let userIsRegisteredPredicate = NSPredicate(format: "%K == %@", #keyPath(User.username), user)
            userReq.predicate = userIsRegisteredPredicate

            let res = try managedObjectContext.fetch(userReq)
            
            // Check if user is registered and password matches.
            if res.count > 0 {
                let entity = res.first
                
                if entity?.username == user && entity?.password == pass {
                    return true
                }
            }
        } catch {
            print("Authetication failure: \(error)")
        }
        
        return false
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        // Do nothing.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Login"
        
        // Initialize CoreData ManagedObjectContext.
        createMainContext {
            container in
            
            let mainContext = container.viewContext
            self.managedObjectContext = mainContext
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRegistrationView" {
            let dest = segue.destination as! RegisterViewController
            dest.managedObjectContext = self.managedObjectContext
        }
    }

}
