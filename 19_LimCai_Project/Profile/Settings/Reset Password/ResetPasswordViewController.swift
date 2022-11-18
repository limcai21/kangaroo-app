//
//  ResetPasswordViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var resetStackView: UIStackView!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var retypePasswordLabel: UITextField!
    
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    var comingFrom = ""
    
    var tempUsername: String?
    
    @IBOutlet weak var resetEmail: UITextField!
    
    
    
    // MARK: - CONTINUE BUTTON
    @IBAction func continueBtn(_ sender: Any) {
        if (resetEmail.text != "") {
            if (comingFrom == "profile") {
                checkValidOldPasswordFromSetting()
            }
            
            else {
                checkValidEmailFromHomeReset()
            }
        }
        
        else {
            var alertMessage = ""
            if (comingFrom == "profile") {
                alertMessage = "Please fill in your old password"
            }
            
            else {
                alertMessage = "Please fill in your email adress"
            }
            
            let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - RESET PASSWORD USING EMAIL
    // check if email exist
    func checkValidEmailFromHomeReset() {
        let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate = NSPredicate(format: "email like '" + resetEmail.text! + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allUsers = try viewContext.fetch(fetchRequest)

            if (allUsers.isEmpty) {
                let alert = UIAlertController(title: "Error", message: "Invalid email", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            else {
                resetStackView.isHidden = false
                emailStackView.isHidden = true
                
                for users in allUsers {
                    tempUsername = users.username
                }
            }
        }
        
        catch {
            print(error)
        }
    }

    
    
    // MARK: - RESET PASSWORD FROM SETTING (USING OLD PASSWORD)
    func checkValidOldPasswordFromSetting() {
        let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "' and password like '" + resetEmail.text! + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allUsers = try viewContext.fetch(fetchRequest)

            if (allUsers.isEmpty) {
                let alert = UIAlertController(title: "Error", message: "Invalid password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            else {
                tempUsername = username
                resetStackView.isHidden = false
                emailStackView.isHidden = true
            }
        }
        
        catch {
            print(error)
        }
    }
    
    
    
    
    
    
    // MARK: - RESET BUTTON
    @IBAction func resetBtn(_ sender: Any) {
        if (passwordLabel.text != "") && (retypePasswordLabel.text != "") {
            if (passwordLabel.text == retypePasswordLabel.text) {
                actualResetPassword(password: retypePasswordLabel.text!)
            }
            
            else {
                let alert = UIAlertController(title: "Error", message: "Please make sure both the password are the same", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        else {
            let alert = UIAlertController(title: "Error", message: "Please enter all the field", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    

    
    // MARK: - ACTUAL RESET PASSWORD FUNCTION
    func actualResetPassword(password: String) {
        let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + tempUsername! + "'")
        fetchRequest.predicate = predicate


        do {
            let allUsers = try viewContext.fetch(fetchRequest)

            for user in allUsers {
                user.password = password
                app.saveContext()
            }

            let alert = UIAlertController(title: "Completed", message: "Your password has reset. Please login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {action in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)

        }

        catch {
            print(error)
        }
    }
    
    
    // MARK: - OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .default
        viewContext = app.persistentContainer.viewContext
        resetStackView.isHidden = true
        emailStackView.isHidden = false
        

        print(comingFrom)
        
        if (comingFrom == "profile") {
            resetEmail.isSecureTextEntry = true
            firstLabel.text = "Old Password: "
        }
        
        else {
            firstLabel.text = "Email: "
        }
        
        resetEmail.addBottomBorderLineWithColor(width: 2.0)
        passwordLabel.addBottomBorderLineWithColor(width: 2.0)
        retypePasswordLabel.addBottomBorderLineWithColor(width: 2.0)

        self.hideKeyboardWHenTappedAround()
        
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
