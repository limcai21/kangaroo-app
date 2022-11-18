//
//  SigninViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class SigninViewController: UIViewController {
    
    
    @IBOutlet weak var emailUsernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    let userDefaults = UserDefaults.standard

    
    // MARK: - LOGIN BUTTON
    @IBAction func loginBtn(_ sender: Any) {
        if (emailUsernameLabel.text != "") && (passwordLabel.text != "") {
            login(emailUsername: emailUsernameLabel.text!, password: passwordLabel.text!)
        }
        
        else {
            let alert = UIAlertController(title: "Error", message: "Please enter all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    // MARK: - LOGIN FUNCTION
    func login(emailUsername: String, password: String) {
        let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + emailUsername + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allUser = try viewContext.fetch(fetchRequest)
            
            if (allUser.isEmpty) {
                let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
                let predicate = NSPredicate(format: "email like '" + emailUsername + "'")
                fetchRequest.predicate = predicate
                
                do {
                    let allUser = try viewContext.fetch(fetchRequest)
                    
                    var checkPassword: String?
                    var checkUsername: String?
                    
                    for user in allUser {
                        checkPassword = user.password
                        checkUsername = user.username
                    }
                                        
                    if (allUser.isEmpty) {
                        let alert = UIAlertController(title: "Error", message: "Invalid username of password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    
                    else {
                        if (password == checkPassword) {
                            userDefaults.set(["username": checkUsername], forKey: "logonUser")
                            let darkModeOnOff = UserDefaults.standard.bool(forKey: "\(checkUsername!)DarkModeSetting")
                            
                            let delegate = UIApplication.shared.windows.first
                            
                            if (darkModeOnOff) {
                                delegate?.overrideUserInterfaceStyle = .dark
                            }
                            
                            else {
                                delegate?.overrideUserInterfaceStyle = .light
                            }
                            
                            performSegue(withIdentifier: "toHome", sender: nil)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                        else {
                            let alert = UIAlertController(title: "Error", message: "Invalid username of password", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
                
                catch {
                    print(error)
                }
            }
            
            else {
                var checkPassword: String?
                var checkUsername: String?
                
                for user in allUser {
                    checkPassword = user.password
                    checkUsername = user.username
                }
                                
                if (password == checkPassword) {
                    userDefaults.set(["username": checkUsername], forKey: "logonUser")
                    let darkModeOnOff = UserDefaults.standard.bool(forKey: "\(checkUsername!)DarkModeSetting")
                    
                    let delegate = UIApplication.shared.windows.first
                    
                    if (darkModeOnOff) {
                        delegate?.overrideUserInterfaceStyle = .dark
                    }
                    
                    else {
                        delegate?.overrideUserInterfaceStyle = .light
                    }
                    
                    performSegue(withIdentifier: "toHome", sender: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                else {
                    let alert = UIAlertController(title: "Error", message: "Invalid username of password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
        
        catch {
            print(error)
        }
    }
    
    
    
    // MARK: - OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailUsernameLabel.addBottomBorderLineWithColor(width: 2.0)
        passwordLabel.addBottomBorderLineWithColor(width: 2.0)
        
        navigationController?.navigationBar.barStyle = .default
        viewContext = app.persistentContainer.viewContext
        
        self.hideKeyboardWHenTappedAround()
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}





