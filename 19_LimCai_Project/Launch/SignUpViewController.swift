//
//  SignUpViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData




class SignUpViewController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    let defaults = UserDefaults.standard

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var retypePasswordLabel: UITextField!

    
    // MARK: - SIGN UP BUTTON
    @IBAction func signUpBtn(_ sender: Any) {
        if (usernameLabel.text != "") && (emailLabel.text != "") && (passwordLabel.text != "") && (retypePasswordLabel.text != "") {
            if (passwordLabel.text == retypePasswordLabel.text) {
                let emailinput = emailLabel.text
                if (emailinput!.isValidEmail()) {
                    signUp(username: usernameLabel.text!, email: emailLabel.text!, password: passwordLabel.text!)
                }
                
                else {
                    let alert = UIAlertController(title: "Error", message: "Please enter a valid email", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            else {
                let alert = UIAlertController(title: "Error", message: "Please make sure both the password are the same", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        else {
            let alert = UIAlertController(title: "Error", message: "Please enter all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
       
    
    // MARK:: - SIGN UP FUNCTION
    func signUp(username: String, email: String, password: String) {
        // check if username exist
        let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allUser = try viewContext.fetch(fetchRequest)
            
            if (allUser.isEmpty) {
                
                // check if email exist
                let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
                let predicate = NSPredicate(format: "email like '" + email + "'")
                fetchRequest.predicate = predicate
                
                do {
                    let allUser = try viewContext.fetch(fetchRequest)
                    
                    // if it doesn't exist store it
                    if (allUser.isEmpty) {
                        let insertUser = NSEntityDescription.insertNewObject(forEntityName: "Login", into: viewContext) as! Login
                        insertUser.username = username
                        insertUser.email = email
                        insertUser.password = password
                        insertUser.credits = Int16(200)
                        
                        app.saveContext()
                        
                        defaults.set(false, forKey: "\(username)DarkModeSetting")
                        let alert = UIAlertController(title: "Completed", message: "Sign up complete! You are good to go", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: { action in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert, animated: true)
                        
                    }
                    
                    else {
                        let alert = UIAlertController(title: "Error", message: "Email has been used. Please use a new one", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
                
                catch {
                    print(error)
                }
            }
            
            else {
                let alert = UIAlertController(title: "Error", message: "Username taken. Please get a new one", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        catch {
            print(error)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .default
        viewContext = app.persistentContainer.viewContext
        usernameLabel.addBottomBorderLineWithColor(width: 2.0)
        passwordLabel.addBottomBorderLineWithColor(width: 2.0)
        retypePasswordLabel.addBottomBorderLineWithColor(width: 2.0)
        emailLabel.addBottomBorderLineWithColor(width: 2.0)
        
        self.hideKeyboardWHenTappedAround()
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}



