//
//  ProductDetailViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class ProductDetailViewController: UIViewController, UIScrollViewDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    let defaults = UserDefaults.standard
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
    
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var errorMsgView: UIView!
    @IBOutlet weak var productScrollView: UIScrollView!
    @IBOutlet weak var errorIcon: UIImageView!
    @IBOutlet weak var errorColour: UIView!
    
    var poster: String!
    var gameTitle = ""
    var gameDescription = ""
    var bg1: String?
    var bg2: String?
    var price: Double!
    var platform = [String]()
    var publisher = ""
    var releaseDate = ""
    var developer = ""
    
    var tempArrayToStoreValue: [String] = []

    @IBOutlet weak var topBg: UIImageView!
    @IBOutlet weak var gamePoster: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameCost: UILabel!
    @IBOutlet weak var secondBg: UIImageView!
    @IBOutlet weak var gameDesc: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var xbo: UIButton!
    @IBOutlet weak var xbs: UIButton!
    @IBOutlet weak var ps5: UIButton!
    @IBOutlet weak var ps4: UIButton!
    
    @IBOutlet weak var platformXBS: UIButton!
    @IBOutlet weak var platformXBO: UIButton!
    @IBOutlet weak var platformPS5: UIButton!
    @IBOutlet weak var platformPS4: UIButton!
    
    var tapOnPlatform = false
    var gameQuantity: Int!
    var choosenPlatform: String!
    
    
    
    
    
    
    // MARK: - STEPPER
    @IBAction func quantityStepper(_ sender: UIStepper) {
        quantityLabel.text = String(Int(sender.value))
        gameQuantity = Int(sender.value)
    }

    
    // MARK: - PLATFORM SELECTION
    @IBAction func platformSelection(_ sender: UIButton) {
        tapOnPlatform = true
        
        if (sender.tag == 1) {
            choosenPlatform = "xbox one"
            print("xbox one")
            platformXBO.backgroundColor = UIColor(named: "xbox")
            platformXBS.backgroundColor = UIColor.black
            platformPS4.backgroundColor = UIColor.black
            platformPS5.backgroundColor = UIColor.black
        }
        
        if (sender.tag == 2) {
           choosenPlatform = "xbox series x|s"
           print("xbox series x|s")
           platformXBS.backgroundColor = UIColor(named: "xbox")
           platformXBO.backgroundColor = UIColor.black
           platformPS4.backgroundColor = UIColor.black
           platformPS5.backgroundColor = UIColor.black
       }
        
        if (sender.tag == 3) {
           choosenPlatform = "ps4"
           print("ps4")
           platformPS4.backgroundColor = UIColor(named: "playstation")
           platformXBS.backgroundColor = UIColor.black
           platformXBO.backgroundColor = UIColor.black
           platformPS5.backgroundColor = UIColor.black
       }
        
        if (sender.tag == 4) {
           choosenPlatform = "ps5"
           print("ps5")
           platformPS5.backgroundColor = UIColor(named: "playstation")
           platformXBS.backgroundColor = UIColor.black
           platformPS4.backgroundColor = UIColor.black
           platformXBO.backgroundColor = UIColor.black
       }
    }
    
    
    
    
    // MARK: - ADD TO CART BUTTON
    @IBAction func addToCartBtn(_ sender: Any) {
        let selectedQuantity = quantityLabel.text!
        
        print("add to cart")
        if (tapOnPlatform == false) {
            errorMsgView.isHidden = false
            errorMsgLabel.text = "Please choose a platform"
            errorIcon.image = UIImage(systemName: "exclamationmark.circle.fill")

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                self.errorMsgView.isHidden = true
            }
        }

        else {
            // check for title and username existence in database
            let fetchRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
            let predicate = NSPredicate(format: "title like '" + gameTitle + "' and username like '" + username + "' and platform like '" + choosenPlatform + "'")
            fetchRequest.predicate = predicate
                
            do {
                let allCart = try viewContext.fetch(fetchRequest)
                
                // user does not have the same game and platform inside
                if (allCart.isEmpty) {
                    
                    print("user does not have this game of the same platform ")
                    
                    // insert game
                    let game = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: viewContext) as! Cart
                    game.title = gameTitle
                    game.platform = choosenPlatform
                    game.price = price!
                    game.quantity = Int16(selectedQuantity)!
                    game.username = username
                    game.poster = poster
                    
                    app.saveContext()
                    
                    errorMsgView.isHidden = false
                    errorMsgLabel.text = "Done! It has been added to your cart!"
                    errorColour.backgroundColor = UIColor.systemGreen
                    errorIcon.image = UIImage(systemName: "checkmark.circle.fill")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                        self.errorMsgView.isHidden = true
                    }
                }
                
                else {
                    print("user have the same game and platform inside so update")
                
                    for cartGame in allCart {
                        // same platform so update quantity
                        cartGame.quantity = (cartGame.quantity + Int16(selectedQuantity)!)
                        
                        app.saveContext()
                        
                        errorMsgView.isHidden = false
                        errorMsgLabel.text = "Done! Game quantity updated!"
                        errorColour.backgroundColor = UIColor.systemGreen
                        errorIcon.image = UIImage(systemName: "checkmark.circle.fill")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                            self.errorMsgView.isHidden = true
                        }
                    }
                }
            }
            
            catch {
                print(error)
            }
        }
    }
    
    
    
    // MARK: - BUY NOW
    @IBAction func buyNowBtn(_ sender: Any) {
        print("buy now")
        
        if (tapOnPlatform == false) {
            errorMsgView.isHidden = false
            errorMsgLabel.text = "Please choose a platform"
            errorIcon.image = UIImage(systemName: "exclamationmark.circle.fill")

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                self.errorMsgView.isHidden = true
            }
        }

        else {
            // check credit
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
            

            let selectedQuantity = quantityLabel.text!
            
            buyNowArray.removeAll()

            // insert game in tempBuyNow Array
            let stringTitle = gameTitle
            let stringPrice = String(price)
            let stringPlatform = String(choosenPlatform)
            let stringQuantity = selectedQuantity
            let stringPoster = String(poster)
            
                                    
            let calculate = price * Double(selectedQuantity)!
            let doubleStr = String(format: "%.2f", calculate) 
            
            if (Double(doubleStr)! < Double(credit)) {
                buyNowArray.append([stringTitle, stringPrice, stringPlatform, stringQuantity, stringPoster])
                defaults.set(doubleStr, forKey: "cartPrice")
                checkingOfPaymentWay = "buy now"
                performSegue(withIdentifier: "fromBuyNow", sender: nil)
            }
            
            else {
                // if not enough credit to buy
                let alert = UIAlertController(title: "Error", message: "You do not enough credit to continue purchasing", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Top up", style: .default, handler: { action in
                    print("go to top up")
                    self.performSegue(withIdentifier: "toTopUpFromProductDetail", sender: nil)
                }))
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    

    // MARK: - SCROLL VIEW DID SCROLL
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = productScrollView.contentOffset.y / 150
        let statusBarFrame: CGRect
        statusBarFrame = UIApplication.shared.statusBarFrame
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.tag = 100
        view.willRemoveSubview(statusBarView)

        if (offset > 4.4) {
            offset = 4.4
            title = gameTitle
            self.navigationController?.navigationBar.backgroundColor = UIColor(named: "white")
            statusBarView.backgroundColor = UIColor(named: "white")
            view.addSubview(statusBarView)
        }
        
        else {
            title = ""
            self.navigationController?.navigationBar.backgroundColor = .clear
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    
    
    // MARK: - PREPARE SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromBuyNow") {
            let vc = segue.destination as! OrderSummaryViewController
            vc.segueFrom = "buy now"
        }
    }
    
    
    
    
    
    // MARK: - OVERRIDE STUFF
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear

        title = ""
        
        viewContext = app.persistentContainer.viewContext
                
        productScrollView.delegate = self
        
        platformPS4.isHidden = true
        platformPS5.isHidden = true
        platformXBO.isHidden = true
        platformXBS.isHidden = true
        
        xbo.isHidden = true
        xbs.isHidden = true
        ps4.isHidden = true
        ps5.isHidden = true
        
        platformXBO.imageView?.contentMode = .scaleAspectFit
        platformXBS.imageView?.contentMode = .scaleAspectFit
        platformPS5.imageView?.contentMode = .scaleAspectFit
        platformPS4.imageView?.contentMode = .scaleAspectFit
        
        xbs.imageView?.contentMode = .scaleAspectFit
        xbo.imageView?.contentMode = .scaleAspectFit
        ps4.imageView?.contentMode = .scaleAspectFit
        ps5.imageView?.contentMode = .scaleAspectFit
        
        productScrollView.contentInsetAdjustmentBehavior = .never

        stepper.backgroundColor = UIColor(named: "card grey")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        topBg.image = UIImage(named: bg1!)
        gamePoster.image = UIImage(named: poster!)
        gameTitleLabel.text = gameTitle
        let tempPrice = String(format: "%.2f", price!)
        gameCost.text = String("\(tempPrice) CR")
        secondBg.image = UIImage(named: bg2!)
        gameDesc.text = gameDescription
        publisherLabel.text = publisher
        developerLabel.text = developer
        releaseDateLabel.text = releaseDate
        
        
        for selectedPlatform in platform {
            print(selectedPlatform)
            
            if (selectedPlatform == "xbox one") {
                platformXBO.isHidden = false
                xbo.isHidden = false
            }
            
            if (selectedPlatform == "xbox series x|s") {
                platformXBS.isHidden = false
                xbs.isHidden = false
            }
            
            if (selectedPlatform == "ps4") {
                platformPS4.isHidden = false
                ps4.isHidden = false
            }
            
            if (selectedPlatform == "ps5") {
                platformPS5.isHidden = false
                ps5.isHidden = false
            }
        }
    }
}



