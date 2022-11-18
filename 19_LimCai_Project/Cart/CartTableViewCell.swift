//
//  CartTableViewCell.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 16/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData


class CartTableViewCell: UITableViewCell {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    let defaults = UserDefaults.standard
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)

    @IBOutlet weak var gamePoster: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gamePrice: UILabel!
    @IBOutlet weak var gameQuantity: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
    @IBOutlet weak var minusBtnStyle: UIButton!
    @IBOutlet weak var plusBtnStyle: UIButton!
    @IBOutlet weak var xbo: UIButton!
    @IBOutlet weak var xbs: UIButton!
    @IBOutlet weak var ps4: UIButton!
    @IBOutlet weak var ps5: UIButton!
    
    var quantityFromDatabase: Int?
    var choosenPlatform: String?
    var addedQuantity: Int?
    var gameCost: Double?
    

    
    
    
    
    // MARK: - ADD BUTTON
    @IBAction func addBtn(_ sender: Any) {
        print("add")
        
        let fetchRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "title like '" + gameTitle.text! + "' and username like '" + username + "' and platform like '" + choosenPlatform! + "'")
        fetchRequest.predicate = predicate
        
        do {
            // get title 
            let allCartGames = try viewContext.fetch(fetchRequest)
            for game in allCartGames {
                addedQuantity = Int(game.quantity + 1)
                game.quantity = Int16(addedQuantity!)
                gameQuantity.text = String(addedQuantity!)
                
                let convertPrice = String(format: "%.2f", game.price * Double(addedQuantity!))
                
                gamePrice.text = "\(convertPrice) CR"
                                    
                app.saveContext()
                
                // trigger action in view controller
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableData"), object: nil)
            }
        }

            
        catch {
            print(error)
        }
    }
    
    
    
    // MARK: - MINUS BUTTON
    @IBAction func minusBtn(_ sender: Any) {
        let fetchRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "title like '" + gameTitle.text! + "' and username like '" + username + "' and platform like '" + choosenPlatform! + "'")
        fetchRequest.predicate = predicate
            
        do {
            let allCart = try viewContext.fetch(fetchRequest)
            
            for game in allCart {
                // prevent user from going negative quantity
                if (game.quantity <= 2) {
                    print("show alert")
                    plusBtnStyle.isEnabled = true
                    minusBtnStyle.isEnabled = false
                    
                    addedQuantity = Int(game.quantity - 1)
                    game.quantity = Int16(addedQuantity!)
                    
                    gameQuantity.text = String(addedQuantity!)
                    
                    let convertPrice = String(format: "%.2f", game.price * Double(addedQuantity!))
                    gamePrice.text = "\(convertPrice) CR"

                    app.saveContext()
                    
                    // trigger action in view controller
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableData"), object: nil)
                }
                
                else {
                    plusBtnStyle.isEnabled = true
                    minusBtnStyle.isEnabled = true
                    
                    addedQuantity = Int(game.quantity - 1)
                    game.quantity = Int16(addedQuantity!)
                    
                    gameQuantity.text = String(addedQuantity!)
                    
                    let convertPrice = String(format: "%.2f", game.price * Double(addedQuantity!))
                    gamePrice.text = "\(convertPrice) CR"

                    app.saveContext()
                    
                    // trigger action in view controller
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableData"), object: nil)
                }
            }
        }

        catch {
            print(error)
        }
    }
    
    
    
    // MARK: - SETUP
    func setup(game: Array<Any>) {
        viewContext = app.persistentContainer.viewContext
        
        
        gameTitle.text = game[0] as? String
        
        xbo.isHidden = true
        xbs.isHidden = true
        ps4.isHidden = true
        ps5.isHidden = true
        
        xbo.imageView?.contentMode = .scaleAspectFit
        xbs.imageView?.contentMode = .scaleAspectFit
        ps4.imageView?.contentMode = .scaleAspectFit
        ps5.imageView?.contentMode = .scaleAspectFit
        
        xbo.layer.cornerRadius = 5
        
        quantityFromDatabase = game[3] as? Int
        
        let selectedPlatform = game[2] as! String
        choosenPlatform = selectedPlatform
        
        if (selectedPlatform == "xbox one") {
            xbo.isHidden = false
        }
        
        if (selectedPlatform == "xbox series x|s") {
            xbs.isHidden = false
        }
        
        if (selectedPlatform == "ps4") {
            ps4.isHidden = false
        }
        
        if (selectedPlatform == "ps5") {
            ps5.isHidden = false
        }
        
        gameQuantity.text = game[3] as? String
        gamePoster.image = UIImage(named: game[4] as! String)
        
        let temp = game[3] as? String
        let intTemp = Int(temp!)
       
        
        if (intTemp! <= 1) {
            minusBtnStyle.isEnabled = false
            plusBtnStyle.isEnabled = true
        }

        else {
            minusBtnStyle.isEnabled = true
            plusBtnStyle.isEnabled = true
        }
        
        
        // calculate total price for jsut this one game	
        let doublePrice = Double((game[1] as? String)!)!
        let totalQuantity = Double((game[3] as? String)!)!
        let gamePriceForCalculate = doublePrice * totalQuantity
        let doubleStr = String(format: "%.2f", gamePriceForCalculate)
        gamePrice.text = "\(doubleStr) CR"
        totalCost += gamePriceForCalculate
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
