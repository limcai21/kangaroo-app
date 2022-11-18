//
//  OrderHistoryTableViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 24/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData


class OrderHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var orderHistoryTableView: UITableView!
    @IBOutlet weak var noOrderHistoryView: UIView!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    var allBroughtProduct = [[String]]()

    
    @IBAction func startShoppingBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBroughtProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryCell", for: indexPath) as! OrderHistoryTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.setup(game: allBroughtProduct[indexPath.row])
        return cell
    }
    
    
    
    
    // MARK: - OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderHistoryTableView.delegate = self
        orderHistoryTableView.dataSource = self
        orderHistoryTableView.separatorStyle = .none

        viewContext = app.persistentContainer.viewContext
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
                
        // display data 
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)

        allBroughtProduct.removeAll()
        
        let fetchRequest: NSFetchRequest <Buy> = Buy.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allUserBroughtProduct = try viewContext.fetch(fetchRequest)
            
            if (allUserBroughtProduct.isEmpty) {
                print("he didnt buy any producct")
            }
            
            else {
                for product in allUserBroughtProduct {
                    let productTitle = String(product.title!)
                    let productPlatform = String(product.platform!)
                    let productQuantity = String(product.quantity)
                    let productPrice = String(product.price)
                    let productImage = String(product.poster!)
                    let productDate = String(product.date!)
                    let productTime = String(product.time!)
                    
                    allBroughtProduct.append([productTitle, productPrice, productPlatform, productQuantity, productImage, productDate, productTime])
                }
            }
        }
        
        catch {
            print(error)
        }
        
        
        
        // show or hide view if there is any history
        if (allBroughtProduct.count <= 0) {
            orderHistoryTableView.isHidden = true
            noOrderHistoryView.isHidden = false
        }
        
        else {
            orderHistoryTableView.isHidden = false
            noOrderHistoryView.isHidden = true
        }
        
    }
}


