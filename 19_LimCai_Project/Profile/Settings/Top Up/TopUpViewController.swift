//
//  ChangeUsernameViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 16/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData
import StoreKit

class TopUpViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    @IBOutlet weak var newUsername: UITextField!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
    
    
    
    var selectedPriceTag = 0
    var models = [SKProduct]()
    var choosenAmount = 0

    enum Product: String, CaseIterable {
        case tenDollar = "com.kangaroo.10"
        case fifthyDollar = "com.kangaroo.50"
        case hundredDollar = "com.kangaroo.100"
        case fiveHundredDollar = "com.kangaroo.500"
    }

    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap( { $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
        
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print(response.products)
            self.models = response.products
        }
    }
    
    
    

    @IBAction func choosenAmount(_ sender: UIButton) {
        if (sender.tag == 0) {
            selectedPriceTag = 0
            choosenAmount = 10
        }
        
        if (sender.tag == 1) {
            selectedPriceTag = 1
            choosenAmount = 50
        }
        
        if (sender.tag == 2) {
            selectedPriceTag = 2
            choosenAmount = 100
        }
        
        if (sender.tag == 3) {
            selectedPriceTag = 3
            choosenAmount = 500
        }
        
        
        
        if #available(iOS 14, *) {
            print(selectedPriceTag, choosenAmount)
            print("from ios 14")
            let payment = SKPayment(product: models[selectedPriceTag])
            SKPaymentQueue.default().add(payment)
        }
        
        else {
            print(selectedPriceTag, choosenAmount)
            updateUserCredit(tag: selectedPriceTag, amount: choosenAmount)
            print("from ios 14 <")

        }
        
    }
    
    
    
    
    
    
    
    func updateUserCredit(tag: Int, amount: Int) {
        // update user credit
        let fetchRequest: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allUser = try viewContext.fetch(fetchRequest)
            
            if (allUser.isEmpty) {
                let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            
            else {
                for user in allUser {
                    user.credits = user.credits + Int16(amount)
                    app.saveContext()
                }
                
                let alert = UIAlertController(title: "Completed", message: "Updated your total credit.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alert, animated: true)
            }
        }
        
        catch {
            print(error)
        }
    }
    
    
    
    // MARK: - MARK IOS 14 > PURCHASING CREDIT
    var purchaseStatus = ""
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                purchaseStatus = "purchasing"
            case .purchased:
                purchaseStatus = "purchased"
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                purchaseStatus = "failed"
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
            
            if (purchaseStatus == "purchased") {
                updateUserCredit(tag: selectedPriceTag, amount: choosenAmount)
            }
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext

        let alert = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SKPaymentQueue.default().add(self)
            self.fetchProducts()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
