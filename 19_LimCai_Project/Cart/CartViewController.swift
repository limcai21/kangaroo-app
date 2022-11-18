//
//  CartTableViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 16/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData



class CartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noCartView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bottomButtonStackView: UIStackView!
    @IBOutlet weak var checkOutBtnStyle: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    let defaults = UserDefaults.standard
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
    
    var tempUserCredit: Int16 = 0
    var tempTotal: Double = 0.0
    var tempPrice: Double = 0.0
    
    // MARK: - START SHOPPING BTN
    @IBAction func startShoppingBtn(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (tempUserCart.count == 0) {
            noCartView.isHidden = false
            bottomButtonStackView.isHidden = true
            totalLabel.isHidden = true
            checkOutBtnStyle.isHidden = true
            tableView.isHidden = true
            
            return 0
        }
        
        else {
            noCartView.isHidden = true
            bottomButtonStackView.isHidden = false
            totalLabel.isHidden = false
            checkOutBtnStyle.isHidden = false
            tableView.isHidden = false
            
            return tempUserCart.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        cell.setup(game: tempUserCart[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let getTitle = tempUserCart[indexPath.row][0]
            let getPlatform = tempUserCart[indexPath.row][2]

            let requestRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
            let predicate = NSPredicate(format: "username like '" + username + "' ")
            requestRequest.predicate = predicate

            do {
                let allGame = try viewContext.fetch(requestRequest)

                for game in allGame {
                    print(game.title!)
                    
                    if (game.title! == getTitle) {
                        if (game.platform! == getPlatform) {
                            viewContext.delete(game)
                            app.saveContext()
                            
                            tempPrice = 0
                            tableView.beginUpdates()
                            tempUserCart.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                            update()
                            tableView.reloadData()
                            tableView.endUpdates()
                            
                            
                            if (tempUserCart.count != 0) {
                                self.navigationController?.tabBarItem.badgeValue = String(tempUserCart.count)
                                
                                noCartView.isHidden = true
                                bottomButtonStackView.isHidden = false
                                totalLabel.isHidden = false
                                checkOutBtnStyle.isHidden = false
                                tableView.isHidden = false
                            }
                            
                            else {
                                self.navigationController?.tabBarItem.badgeValue = nil
                                
                                noCartView.isHidden = false
                                bottomButtonStackView.isHidden = true
                                totalLabel.isHidden = true
                                checkOutBtnStyle.isHidden = true
                                tableView.isHidden = true
                            }
                        }
                    }
                }
            }

            catch {
                print(error)
            }
            
        }
    }
    
    
    
    // MARK: - CHECK OUT BUTTON
    @IBAction func checkOutBtn(_ sender: Any) {
        
        // get user credit
        let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers {
                tempUserCredit = user.credits
            }
            
            // compare total and available credit
            if (tempPrice > Double(tempUserCredit)) {
                let alert = UIAlertController(title: "Error", message: "You do not enough credit to continue purchasing.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Top up", style: .default, handler: { action in
                    print("go to top up")
                    self.performSegue(withIdentifier: "toTopUpFromCart", sender: nil)
                }))
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            
            else {
                let doubleStr = String(format: "%.2f", tempPrice)
                defaults.set(doubleStr, forKey: "cartPrice")
                checkingOfPaymentWay = "cart"
                performSegue(withIdentifier: "toOrderSummary", sender: nil)
            }
            
        }
        
        catch {
            print(error)
        }
    }
    
    

    
    // MARK: - UPDATE (RELOAD)
    func update() {
        tempUserCart.removeAll()

        // get user cart informations
        let requestRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        requestRequest.predicate = predicate

        do {
            let allGame = try viewContext.fetch(requestRequest)

            for game in allGame {
                let stringTitle = String(game.title!)
                let stringPrice = String(game.price)
                let stringPlatfom = String(game.platform!)
                let stringQuantity = String(game.quantity)
                let stringPoster = String(game.poster!)

                tempUserCart.append([stringTitle, stringPrice, stringPlatfom, stringQuantity, stringPoster])
            }
        }

        catch {
            print(error)
        }

        var counter = 0
        tempPrice = 0.0
        
        // store inside a temp array to display in the tableview
        for _ in tempUserCart {
            let singlePrice: Double = Double(tempUserCart[counter][1])!
            let gameQuantity: Double = Double(tempUserCart[counter][3])!
            let calculate = singlePrice * gameQuantity

            tempPrice += calculate
            counter += 1
        }

        let doubleStr = String(format: "%.2f", tempPrice)
        
        totalLabel.text = "Total: \(doubleStr) CR"
        tableView.reloadData()
    }
    
    
    
    
    //  MARK: - RELOAD TABLE VIEW CONTROLLER WHEN MINUS & PLUS IS TAP
    @objc func reloadTableDataForPlusMinus() {
        tempUserCart.removeAll()
        
        // get user cart informations
        let requestRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        requestRequest.predicate = predicate
        
        do {
            let allGame = try viewContext.fetch(requestRequest)
            for game in allGame {
                let stringTitle = String(game.title!)
                let stringPrice = String(game.price)
                let stringPlatfom = String(game.platform!)
                let stringQuantity = String(game.quantity)
                let stringPoster = String(game.poster!)
                
                tempUserCart.append([stringTitle, stringPrice, stringPlatfom, stringQuantity, stringPoster])
            }
            
            let requestRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
            let predicate = NSPredicate(format: "username like '" + username + "'")
            requestRequest.predicate = predicate


            // reset all value
            var counter = 0
            tempPrice = 0
            
            // store inside a temp array to display in the tableview
            for _ in tempUserCart {
                let singlePrice: Double = Double(tempUserCart[counter][1])!
                let gameQuantity: Double = Double(tempUserCart[counter][3])!
                let calculate = singlePrice * gameQuantity
                
                tempPrice += calculate
                counter += 1
            }

            let doubleStr = String(format: "%.2f", tempPrice)

            totalLabel.text = "Total: \(doubleStr) CR"
            tableView.reloadData()
        }
        
        catch {
            print(error)
        }
    }
    
    
    
    // MARK: - overrideLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allGames = try viewContext.fetch(fetchRequest)
            var counter = 0
            for _ in allGames {
                counter += 1
            }
            
            let tabItems = tabBarController?.tabBar.items
            let tabItem = tabItems![2]

            
            if (counter == 0) {
                tabItem.badgeValue = nil
            }
            
            else {
                tabItem.badgeValue = String(counter)
            }
        }
        
        catch {
            print(error)
        }
        
        // LOAD CART & Update
        self.update()
        
        // activate the action at table view cell (plus and minus button)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableDataForPlusMinus), name: Notification.Name(rawValue: "reloadTableData"), object: nil)

    }
}

