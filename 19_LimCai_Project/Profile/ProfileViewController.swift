//
//  ProfileViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData


var editAddressComeFromProfile = false

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var loginUsername: UILabel!
    @IBOutlet weak var settingTable: UITableView!
    
    let defaultImage = UIImage(named: "user")
    let userDefaults = UserDefaults.standard
    
    var darkModeOnOff: Bool = false
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    
    
    
    
    
    enum SettingSection: Int, CaseIterable, CustomStringConvertible {
        case Setting = 0
        case Others = 1

        var description: String {
            switch self {
            case .Setting: return "Settings"
            case .Others: return "Others"
            }
        }
    }

    enum ProfileOption: Int, CaseIterable, CustomStringConvertible {
        case TopUpCredit
        case ChangePassword
        case Address
        case OrderHistory
        case WeatherTracker
        case DarkMode
        case DeleteAccount

        var description: String {
            switch self {
                case .TopUpCredit: return "Top Up"
                case .ChangePassword: return "Change Password"
                case .Address: return "Your Address"
                case .WeatherTracker: return "Weather Tracker"
                case .OrderHistory: return "Order History"
                case .DarkMode: return "Dark Mode"
                case .DeleteAccount: return "Delete Account"
            }
        }

        var icon: String {
            switch self {
                case .TopUpCredit: return "addCredit"
                case .ChangePassword: return "changePassword"
                case .Address: return "address"
                case .OrderHistory: return "orderHistory"
                case .WeatherTracker: return "weather"
                case .DarkMode: return "dark"
                case .DeleteAccount: return "deleteAccount"
            }
        }
    }

    enum OthersOption: Int, CaseIterable, CustomStringConvertible {
        case Logout

        var description: String {
            switch self {
            case .Logout: return "Logout"
            }
        }

        var icon: String {
            switch self {
                case .Logout: return "logout"
            }
        }
    }

    
    
    
    
    
    // MARK: - TABLEVIEW SETTINGS
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingSection(rawValue: section) else { return 0 }
        
        switch section {
            case .Setting: return ProfileOption.allCases.count
            case .Others: return OthersOption.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell

        guard let section = SettingSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        
        switch section {
            case .Setting:
                if (indexPath.row == 6) {
                    cell.accessoryType = .none
                }
            
                if (indexPath.row == 5) {
                    let profile = ProfileOption(rawValue: indexPath.row)
                    cell.titleLabel?.text = profile?.description
                    cell.icon.image = UIImage(named: (profile?.icon)!)
                    cell.switcher.isHidden = false
                    cell.switcher.setOn(darkModeOnOff, animated: true)
                    cell.accessoryType = .none
                    cell.selectionStyle = .none
                }
                
                else {
                    let profile = ProfileOption(rawValue: indexPath.row)
                    cell.titleLabel?.text = profile?.description
                    cell.icon.image = UIImage(named: (profile?.icon)!)
                    cell.switcher.isHidden = true
                    cell.accessoryType = .disclosureIndicator
                }
            case .Others:
                let others = OthersOption(rawValue: indexPath.row)
                cell.titleLabel?.text = others?.description
                cell.icon.image = UIImage(named: (others?.icon)!)
                cell.switcher.isHidden = true
                cell.accessoryType = .disclosureIndicator
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        enum SettingSection: Int, CaseIterable, CustomStringConvertible {
            case Profile = 0
            case Others = 1
            
            var description: String {
                switch self {
                case .Profile: return "Settings"
                case .Others: return "Others"
                }
            }
        }
        
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.textColor = .white
        title.text = SettingSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = indexPath.section
        let selectedRow = indexPath.row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Settings
        if (selectedSection == 0) {
            // Change username
            if (selectedRow == 0) {
                performSegue(withIdentifier: "toTopUp", sender: nil)
            }
            
            // Change password
            if (selectedRow == 1) {
                performSegue(withIdentifier: "toResetPassword", sender: nil)
            }
            
            // Edit address
            if (selectedRow == 2) {
                editAddressComeFromProfile = true
                performSegue(withIdentifier: "toEditAddress", sender: nil)
            }
            
            if (selectedRow == 3) {
                performSegue(withIdentifier: "toOrderHistory", sender: nil)
            }
            
            if (selectedRow == 4) {
                performSegue(withIdentifier: "toWeatherTracker", sender: nil)
            }
            
            // delete account
            if (selectedRow == 6) {
                let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: "This can't be undo", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in

                    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
                    let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
                    let predicate = NSPredicate(format: "username like '" + username + "'")
                    fetchRequest.predicate = predicate
                    
                    do {
                        let allUser = try self.viewContext.fetch(fetchRequest)
                        
                        if (allUser.isEmpty) {
                            let alert = UIAlertController(title: "Error", message: "We can't seem to delete your account now. Try again later.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dimiss", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        
                        else {
                            for user in allUser {
                                self.viewContext.delete(user)
                                self.app.saveContext()
                            }
                            
                            
                            // delete cart
                            let fetchRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
                            let predicate = NSPredicate(format: "username like '" + username + "'")
                            fetchRequest.predicate = predicate
                            
                            do {
                                let allUserCart = try self.viewContext.fetch(fetchRequest)
                                
                                for cart in allUserCart {
                                    self.viewContext.delete(cart)
                                    self.app.saveContext()
                                }
                                
                                // delete address
                                let fetchRequest2: NSFetchRequest <Address> = Address.fetchRequest()
                                let predicate2 = NSPredicate(format: "username like '" + username + "'")
                                fetchRequest.predicate = predicate2
                                
                                do {
                                    let allAddress = try self.viewContext.fetch(fetchRequest2)
                                    
                                    for address in allAddress {
                                        self.viewContext.delete(address)
                                        self.app.saveContext()
                                    }
                                    
                                    // delete pp
                                    UserDefaults.standard.removeObject(forKey: "\(username)PP")
                                    choosenAddress.removeAll()
                                    
                                    // delete order history
                                    let fetchRequest3: NSFetchRequest <Buy> = Buy.fetchRequest()
                                    let predicate3 = NSPredicate(format: "username like '" + username + "'")
                                    fetchRequest.predicate = predicate3
                                    
                                    do {
                                        let allAddress = try self.viewContext.fetch(fetchRequest3)
                                        
                                        for address in allAddress {
                                            self.viewContext.delete(address)
                                            self.app.saveContext()
                                        }
                                                                                    
                                        let alert = UIAlertController(title: "Completed", message: "Account deleted successfully. \nYou are now logging out...", preferredStyle: .alert)
                                        self.present(alert, animated: true)
                                        self.userDefaults.set(["username": ""], forKey: "logonUser")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                            self.dismiss(animated: true)
                                            self.dismiss(animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    catch {
                        print(error)
                    }
                    
                }))
                self.present(alert, animated: true)
            }
        }
        
        if (selectedSection == 1) {
            if (selectedRow == 0) {
                // action sheet doesn't work on ipad unless using popover
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    print("ipad")
                    let alert = UIAlertController(title: "Are you sure you want to logout?", message: "You still can login later on", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
                        choosenAddress.removeAll()
                        self.userDefaults.set(["username": ""], forKey: "logonUser")
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
                
                else {
                    print("others")
                    let alert = UIAlertController(title: "Are you sure you want to logout?", message: "You still can login later on", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
                        choosenAddress.removeAll()
                        self.userDefaults.set(["username": ""], forKey: "logonUser")
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    // MARK: - SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toResetPassword") {
            let vc = segue.destination as! ResetPasswordViewController
            vc.title = "Change Password"
            vc.comingFrom = "profile"
        }
        
        
        if (segue.identifier == "toTopUp") {
            
        }
    }

    
    
    

    // MARK: - CHANGE PROFILE PIC FUNCTION
    @IBAction func changeProfilePic(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    
    
    
    
    // MARK: - OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        
        settingTable.dataSource = self
        settingTable.delegate = self
        settingTable.tableFooterView = UIView()
        
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
        darkModeOnOff = userDefaults.bool(forKey: "\(username)DarkModeSetting")
        
        
        let data = UserDefaults.standard.object(forKey: "\(username)PP") as? NSData

        if data == nil {
            print("No Profile Picture")
        }
        
        else {
            profilePic.image = UIImage(data: data! as Data)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
        loginUsername.text = username
        
        let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        var credit: Int16 = 0
        
        do {
            let allUsers = try viewContext.fetch(fetchRequest)
            
            for user in allUsers {
                credit = user.credits
            }
        }
        
        catch {
            print(error)
        }
        
                        
        creditLabel.text = "\(credit)"
    }
}




extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profilePic.image = image
            let imageData:NSData = image.pngData()! as NSData
            let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)

            UserDefaults.standard.set(imageData, forKey: "\(username)PP")
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

