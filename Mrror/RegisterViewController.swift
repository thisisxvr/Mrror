//
//  RegisterViewController.swift
//  Mrror
//
//  Created by Xavier Francis on 23/09/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var usernameTxtBox: UITextField!
    @IBOutlet weak var passwordTxtBox: UITextField!
    @IBOutlet weak var occupationTxtBox: UITextField!
    @IBOutlet weak var genderTxtBox: UITextField!
    @IBOutlet weak var ageGroupTxtBox: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    let occupationPicker = UIPickerView()
    let genderPicker = UIPickerView()
    let ageGroupPicker = UIPickerView()
    let occupationsPickerData = ["Tinker", "Tailor", "Soldier", "Sailor", "Doctor", "Lawyer", "Merchant", "Thief", "Priest", "Programmer"]
    let genderPickerData = ["Male", "Female", "I do not identify with any of the above"]
    let ageGroupPickerData = ["10-18", "19-29", "30-45", "45-60", "60+"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Register"
        
        occupationTxtBox.inputView = occupationPicker
        occupationPicker.delegate = self
        
        genderTxtBox.inputView = genderPicker
        genderPicker.delegate = self
        
        ageGroupTxtBox.inputView = ageGroupPicker
        ageGroupPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerBtnDidClick(_ sender: Any) {
        let username = usernameTxtBox?.text
        let password = passwordTxtBox?.text
        let occupation = occupationTxtBox?.text
        let gender = genderTxtBox?.text
        let ageGroup = ageGroupTxtBox?.text
        
        let userEntity = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: managedObjectContext) as! User
        let userReq = NSFetchRequest<User>(entityName: User.entityName)
        
        if let uname = username {
            let usernameExistsPredicate = NSPredicate(format: "%K == %@", #keyPath(User.username), uname)
            userReq.predicate = usernameExistsPredicate
            
            do {
                // If username exists, tell the user to change it...
                let possibleUsernameConflict = try managedObjectContext.fetch(userReq)
                if possibleUsernameConflict.count > 0 {
                    let alert = UIAlertController(title: "😖\nUsername exists", message: "Pick a different username", preferredStyle: .alert)
                    let kay = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(kay)
                    present(alert, animated: true, completion: nil)
                    return
                }
                // ... else, assign it to userEntity field.
                userEntity.username = uname
            } catch {
                print("Username exists error: \(error)")
            }
        }
        
        if let pass = password {
            if isPasswordValid(pass) {
                userEntity.password = pass
            } else {
                let alert = UIAlertController(title: "😖\nPassword verification fails", message: "\nMUST CONTAIN:\nAt least one uppercase\nAt least one lowercase\nAt least one digit\nAt least 6 characters", preferredStyle: .alert)
                let kay = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(kay)
                present(alert, animated: true, completion: nil)
                return
            }
        }
        
        if let occ = occupation { userEntity.occupation = occ }
        if let gen = gender { userEntity.gender = gen }
        if let age = ageGroup { userEntity.ageGroup = age }
        userEntity.registrationTime = Date.init()
        
        // Persist to DB.
        do {
            try managedObjectContext.save()
            
            // Success alert.
            let alert = UIAlertController(title: "😃\nAccount created", message: "Please login before using the app", preferredStyle: .alert)
            let kay = UIAlertAction(title: "OK", style: .default, handler: {
                _ in
                self.performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
            })
            alert.addAction(kay)
            present(alert, animated: true, completion: nil)
        } catch {
            print("Something went wrong: \(error)")
            managedObjectContext.rollback()
        }
    }
    
    func isPasswordValid(_ password: String?) -> Bool {
        guard password != nil else { return false }
        
        // At least one uppercase,
        // At least one lowercase,
        // At least one digit, and
        // Min 6 characters
        // Adapted from www.regexr.com
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    // MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == occupationPicker) { return occupationsPickerData.count }
        else if (pickerView == genderPicker) { return genderPickerData.count }
        else if (pickerView == ageGroupPicker) { return ageGroupPickerData.count }
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == occupationPicker) { return occupationsPickerData[row] }
        else if (pickerView == genderPicker) { return genderPickerData[row] }
        else if (pickerView == ageGroupPicker) { return ageGroupPickerData[row] }
        return " "
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == occupationPicker) { occupationTxtBox.text = occupationsPickerData[row] }
        else if (pickerView == genderPicker) { genderTxtBox.text = genderPickerData[row] }
        else if (pickerView == ageGroupPicker) { ageGroupTxtBox.text = ageGroupPickerData[row] }
    }
}
