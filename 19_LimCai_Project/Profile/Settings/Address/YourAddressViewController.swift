//
//  YourAddressViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 22/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class YourAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var yourAddressTableView: UITableView!
    @IBOutlet weak var noAddressView: UIView!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)    
    var counterForIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = yourAddressTableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
                    
        let area = addressHolder[indexPath.row][0]
        let block = addressHolder[indexPath.row][1]
        let street = addressHolder[indexPath.row][2]
        let unit = addressHolder[indexPath.row][3]
        let postal = addressHolder[indexPath.row][4]
        let contactNo = addressHolder[indexPath.row][5]
        
        cell.addressData.text = "\(area)\nBlock \(block), \(street)\n#\(unit)\nSingapore \(postal)\n\(contactNo)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        counterForIndex = indexPath.row
        performSegue(withIdentifier: "toEditAddressFromYourAddress", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let area = addressHolder[indexPath.row][0]
        let block = addressHolder[indexPath.row][1]
        let street = addressHolder[indexPath.row][2]
        let unit = addressHolder[indexPath.row][3]
        let postal = addressHolder[indexPath.row][4]
        let contactNo = addressHolder[indexPath.row][5]
        
        if editingStyle == .delete {
            let requestRequest: NSFetchRequest <Address> = Address.fetchRequest()
            let predicate1: NSPredicate = NSPredicate(format: "area like '" + area + "'")
            let predicate2: NSPredicate = NSPredicate(format: "block like '" + block + "'")
            let predicate3: NSPredicate = NSPredicate(format: "street like '" + street + "'")
            let predicate4: NSPredicate = NSPredicate(format: "unit like '" + unit + "'")
            let predicate5: NSPredicate = NSPredicate(format: "contactNo like '" + contactNo + "'")
            let predicate6: NSPredicate = NSPredicate(format: "postalCode like '" + postal + "'")
            let predicate7: NSPredicate = NSPredicate(format: "username like '" + username + "'")
            let predicate: NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4, predicate5, predicate6, predicate7] )
            requestRequest.predicate = predicate

            do {
                let allAddress = try viewContext.fetch(requestRequest)

                print(indexPath.row)
                
                for address in allAddress {
                    viewContext.delete(address)
                    app.saveContext()
                }
                            
                yourAddressTableView.beginUpdates()
                addressHolder.remove(at: indexPath.row)
                yourAddressTableView.deleteRows(at: [indexPath], with: .automatic)
                yourAddressTableView.reloadData()
                yourAddressTableView.endUpdates()
                checkIfGotAddressOrNot()
            }

            catch {
                print(error)
            }
            
        }
    }
    
    
    
    
    
    // MARK: - PREPARE SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEditAddressFromYourAddress") {
            let vc = segue.destination as! EditAddressViewController
            vc.comingFrom = "your address"
            vc.area = addressHolder[counterForIndex][0]
            vc.block = addressHolder[counterForIndex][1]
            vc.street = addressHolder[counterForIndex][2]
            vc.unit = addressHolder[counterForIndex][3]
            vc.postal = Int64(addressHolder[counterForIndex][4])
            vc.contactNo = Int64(addressHolder[counterForIndex][5])
            vc.title = "Edit Address"
            vc.comingFrom = "your address"
        }
        
        if (segue.identifier == "fromPlus") {
            let vc = segue.destination as! EditAddressViewController
            vc.title = "Add Address"
            vc.comingFrom = "from plus"
        }
    }
    
    
    
    // MARK: - Check if got address or not

    func checkIfGotAddressOrNot() {
        let fetchRequest2: NSFetchRequest <Address> = Address.fetchRequest()
        let predicate2 = NSPredicate(format: "username like '" + username + "'")
        fetchRequest2.predicate = predicate2
        
        do {
            let allAddress = try viewContext.fetch(fetchRequest2)
            print(allAddress.isEmpty)
            // no address found for user
            if (allAddress.isEmpty) {
                noAddressView.isHidden = false
            }
            
            else {
                noAddressView.isHidden = true
            }
        }
        
        catch {
            print(error)
        }
    }
    
    
    

    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        
        yourAddressTableView.delegate = self
        yourAddressTableView.dataSource = self
        yourAddressTableView.separatorStyle = .none
    }
    
    
    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
        
        let fetchRequest: NSFetchRequest <Address> = Address.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allAddress = try viewContext.fetch(fetchRequest)
            
            addressHolder.removeAll()
            
            // no address found for user
            if (!allAddress.isEmpty) {
                for address in allAddress {
                    let area = address.area!
                    let block = address.block!
                    let street = address.street!
                    let unit = address.unit!
                    let postal = String(address.postalCode)
                    let contactNo = String(address.contactNo)
                    
                    addressHolder.append([area, block, street, unit, postal, contactNo])
                }
            }
        }
        catch {
            print(error)
        }
                
        
        self.update()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAddressTable), name: NSNotification.Name(rawValue: "reloadTableAddress"), object: nil)
        
        checkIfGotAddressOrNot()
    }
    
    
    
    // MARK: - RELOAD TABLEVIEW ADDRESS
    @objc func refreshAddressTable() {
        self.yourAddressTableView.reloadData()
    }
    
    func update() {
        yourAddressTableView.reloadData()
    }
}
