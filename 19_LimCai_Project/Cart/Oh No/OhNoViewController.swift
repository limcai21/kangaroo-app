//
//  OhNoViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 23/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class OhNoViewController: UIViewController {
    
    @IBOutlet weak var todayBtnStyle: UIButton!
    @IBOutlet weak var ohNoScrollView: UIScrollView!
    @IBOutlet weak var choosenAreaLabel: UILabel!
    @IBOutlet weak var weatherDetailLabel: UILabel!
    
    var choosenArea = ""
    var weatherDetails = ""
    
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)

    let formatter = DateFormatter()
    let currentDateTime = Date()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    var whichArray = [[String]]()
    
    var didUserSelectTomorrow = false

    
    
    
    // MARK: - TOMORROW BUTTON
    @IBAction func tommorowBtn(_ sender: Any) {
        print("tomorrow")
        didUserSelectTomorrow = true
        buyProduct()
        insertGameIntoPopularity()
        performSegue(withIdentifier: "toConfirmFromOhNo", sender: nil)
    }
    
    
    // MARK: - TODAY BUTTON
    @IBAction func todayBtn(_ sender: Any) {
        print("today")
        didUserSelectTomorrow = false
        buyProduct()
        insertGameIntoPopularity()
        performSegue(withIdentifier: "toConfirmFromOhNo", sender: nil)
    }
    
    // MARK: - INSERT GAME INTO POPULARITY DATABASE
    func insertGameIntoPopularity() {
        for product in whichArray {
            let fetchRequest: NSFetchRequest <Popularity> = Popularity.fetchRequest()
            let predicate = NSPredicate(format: "title like '" +  product[0] + "'")
            fetchRequest.predicate = predicate
            
            do {
                let allProduct = try viewContext.fetch(fetchRequest)
                
                if (allProduct.isEmpty) {
                    // insert
                    print(product)
                    let popularGame = NSEntityDescription.insertNewObject(forEntityName: "Popularity", into: viewContext) as! Popularity
                    popularGame.title = product[0]
                    popularGame.quantity = Int64(product[3])!
                    
                    app.saveContext()
                    
                    print("new one")
                }
                
                else {
                    // update quantity
                    for game in allProduct {
                        game.quantity = game.quantity + Int64(product[3])!
                        
                        app.saveContext()
                        
                        print("updated popularity quantity")
                    }
                }
            }
            
            catch {
                print(error)
            }
        }
    }
    
    
    // MARK: - BUY FUNCTION
    func buyProduct() {
        if (didUserSelectTomorrow) {
            // update credit
            let fetchRequest2: NSFetchRequest <Login> = Login.fetchRequest()
            let predicate2 = NSPredicate(format: "username like '" + username + "'")
            fetchRequest2.predicate = predicate2
                        
            do {
                let allUser = try viewContext.fetch(fetchRequest2)
                var userCurrentCredit: Int16 = 0
                let totalCost = UserDefaults.standard.string(forKey: "cartPrice")
                
                for user in allUser {
                    userCurrentCredit = user.credits
                    user.credits = Int16((Double(userCurrentCredit) - Double(totalCost!)!).rounded(.down))
                }
                                
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentDateTime)
                
                formatter.dateFormat = "d MMMM yyyy"
                let tmrDate = formatter.string(from: tomorrow!)
                tempDateStoreForVC = tmrDate
                formatter.dateFormat = "HH:mm tt"
                let time = formatter.string(from: tomorrow!)

                // insert into user order history
                for product in whichArray {
                    let insertProduct = NSEntityDescription.insertNewObject(forEntityName: "Buy", into: viewContext) as! Buy
                    insertProduct.title = product[0]
                    insertProduct.price = Double(product[1])!
                    insertProduct.platform = product[2]
                    insertProduct.quantity = Int16(product[3])!
                    insertProduct.poster = product[4]
                    insertProduct.username = username
                    insertProduct.time = time
                    insertProduct.date = tmrDate
                    
                    app.saveContext()
                }
                
                if (whichArray.count > 1) {
                    tempGameStoreForVC = "\(whichArray[0][0]) and others"
                }
                
                else {
                    tempGameStoreForVC = whichArray[0][0]
                    
                }
                
                print("product added (tomorrow)")
            }
            
            catch {
                print(error)
            }
        }
        
        else {
            print(whichArray)
            
            // update credit
            let fetchRequest2: NSFetchRequest <Login> = Login.fetchRequest()
            let predicate2 = NSPredicate(format: "username like '" + username + "'")
            fetchRequest2.predicate = predicate2
                        
            do {
                let allUser = try viewContext.fetch(fetchRequest2)
                var userCurrentCredit: Int16 = 0
                let totalCost = UserDefaults.standard.string(forKey: "cartPrice")
                
                for user in allUser {
                    userCurrentCredit = user.credits
                    user.credits = Int16((Double(userCurrentCredit) - Double(totalCost!)!).rounded(.down))
                }
                
                // date time
                formatter.dateFormat = "d MMMM yyyy"
                let todayDate = formatter.string(from: currentDateTime)
                tempDateStoreForVC = todayDate
                formatter.dateFormat = "HH:mm tt"
                let time = formatter.string(from: currentDateTime)

                // insert into user order history
                for product in whichArray {
                    let insertProduct = NSEntityDescription.insertNewObject(forEntityName: "Buy", into: viewContext) as! Buy
                    insertProduct.title = product[0]
                    insertProduct.price = Double(product[1])!
                    insertProduct.platform = product[2]
                    insertProduct.quantity = Int16(product[3])!
                    insertProduct.poster = product[4]
                    insertProduct.username = username
                    insertProduct.time = time
                    insertProduct.date = todayDate
                    
                    app.saveContext()
                }
                
                if (whichArray.count > 1) {
                    tempGameStoreForVC = "\(whichArray[0][0]) and \(whichArray.count - 1) other"
                }
                
                else {
                    tempGameStoreForVC = whichArray[0][0]
                    
                }
                
                print("product added (today)")
            }
            
            catch {
                print(error)
            }
        }

    }
    
    
    
    
    
    // MARK: - REMOVE ALL CART DATA FUNCTION FOR PEOPLE COMING FROM CART
    func removeUserCart() {
        if (checkingOfPaymentWay == "cart") {
            let fetchRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
            let predicate = NSPredicate(format: "username like '" + username + "'")
            fetchRequest.predicate = predicate
            
            do {
                let allCart = try viewContext.fetch(fetchRequest)
                
                if (allCart.isEmpty) {
                    let alert = UIAlertController(title: "Error", message: "Something seems wrong. Please try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alert, animated: true)
                }
                
                else {
                    for product in allCart {
                        viewContext.delete(product)
                        app.saveContext()
                    }
                }
            }
            
            catch {
                print(error)
            }
        }
        
        else {
            print("from somewhere else")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toConfirmFromOhNo") {
            let vc = segue.destination as! ConfirmViewController
            vc.comingFrom = "oh no"
            vc.parcelDeliveryDate = tempDateStoreForVC
            vc.gameBrought = tempGameStoreForVC
        }
    }
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        
        
        if (checkingOfPaymentWay == "buy now") {
            whichArray = buyNowArray
            print("from buy now")
        }
        
        else {
            whichArray = tempUserCart
            removeUserCart()
            print("from cart")
        }
        
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        ohNoScrollView.contentInsetAdjustmentBehavior = .never
        self.navigationController?.navigationBar.barTintColor = UIColor.black

        
        todayBtnStyle.layer.borderWidth = 2
        todayBtnStyle.layer.borderColor = UIColor.label.cgColor
        
        choosenAreaLabel.text = choosenArea
        weatherDetailLabel.text = weatherDetails
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
