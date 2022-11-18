//
//  OrderSummaryViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 18/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

var userHaveNoAddressInside = false
var haveAddressOrNot: Bool!
var choosenArea = ""
var weatherDetails = ""
var tempGameStoreForVC = ""
var tempDateStoreForVC = ""


class OrderSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderSummaryTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftOverCreditLabel: UILabel!
    @IBOutlet weak var actionBtnStyle: UIButton!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var belowTotalCostLabel: UILabel!
    @IBOutlet weak var orderSummaryTable: UITableView!
    @IBOutlet weak var editOrAddBtnStyle: UIButton!
    @IBOutlet weak var outputAddressLabel: UILabel!
    
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    let defaults = UserDefaults.standard
    var segueFrom = ""
    
    var userCurrentCredit: Int16 = 0
    var leftOverCR: Int16!

    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
    
    var choosenArrayBaseOnComingFrom = [[String]]()

    // for date use
    let currentDateTime = Date()
    let formatter = DateFormatter()
    
    
    // for weather
    struct weatherData: Codable {
        let area_metadata: [area_metadataAray]
        let items: [itemsArray]
        
        
        struct area_metadataAray: Codable {
            let name: String
            let label_location: label_locationArray
        }

        struct label_locationArray: Codable {
            let latitude: Double
            let longitude: Double
        }

        struct itemsArray: Codable {
            let forecasts : [forcastsArray]?
            enum CodingKeys: String, CodingKey {
                case forecasts = "forecasts"
            }
        }

        struct forcastsArray : Codable {
            let area : String?
            let forecast : String?

            enum CodingKeys: String, CodingKey {

                case area = "area"
                case forecast = "forecast"
            }
        }
    }

    
    
    
    // MARK: - TABLE VIEW DATA
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segueFrom == "buy now") {
            return buyNowArray.count
        }
        
        else {
            return tempUserCart.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderSummaryTable.dequeueReusableCell(withIdentifier: "orderSummaryCell", for: indexPath) as! OrderSummaryTableViewCell
        cell.selectionStyle = .none

        if (segueFrom == "buy now") {
            cell.setup(game: buyNowArray[indexPath.row])
        }
        
        else {
            cell.setup(game: tempUserCart[indexPath.row])
        }
        
        return cell
    }
    
    
    
    // MARK: - INSERT GAME INTO POPULARITY DATABASE
    func insertGameIntoPopularity() {
        for product in choosenArrayBaseOnComingFrom {
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
    
    
    
    
    // MARK: - CLEAR CART
    func clearUserCart() {
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
    
    
    
    
    // MARK: - BUY PRODUCT FUNCTION
    func buyProduct() {
                
        // update credit
        let fetchRequest2: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate2 = NSPredicate(format: "username like '" + username + "'")
        fetchRequest2.predicate = predicate2
                    
        do {
            let allUser = try viewContext.fetch(fetchRequest2)
            let totalCost = UserDefaults.standard.string(forKey: "cartPrice")
            
            for user in allUser {
                userCurrentCredit = user.credits
                user.credits = Int16((Double(userCurrentCredit) - Double(totalCost!)!).rounded(.down))
            }
            

            // date time
            formatter.dateFormat = "d MMMM yyyy"
            let todayDate = formatter.string(from: currentDateTime)
            formatter.dateFormat = "HH:mm tt"
            let time = formatter.string(from: currentDateTime)

            tempDateStoreForVC = todayDate
            
            
            if (segueFrom == "buy now") {
                choosenArrayBaseOnComingFrom = buyNowArray
            }
            
            else {
                choosenArrayBaseOnComingFrom = tempUserCart
            }

            // insert into user order history
            for product in choosenArrayBaseOnComingFrom {
                let buyNowProduct = NSEntityDescription.insertNewObject(forEntityName: "Buy", into: viewContext) as! Buy
                buyNowProduct.title = product[0]
                buyNowProduct.price = Double(product[1])!
                buyNowProduct.platform = product[2]
                buyNowProduct.quantity = Int16(product[3])!
                buyNowProduct.poster = product[4]
                buyNowProduct.username = username
                buyNowProduct.time = time
                buyNowProduct.date = todayDate
                
                app.saveContext()
            }
            
            
            if (segueFrom != "buy now") {
                clearUserCart()

                if (tempUserCart.count > 1) {
                    tempGameStoreForVC = "\(tempUserCart[0][0]) and \(tempUserCart.count - 1) other"
                }
                
                else {
                    tempGameStoreForVC = tempUserCart[0][0]
                }
            }
            
            
            else {
                tempGameStoreForVC = buyNowArray[0][0]
            }
        }
        
        catch {
            print(error)
        }
    }
    

    
    

    
    
    // MARK: - PLACE ORDER BUTTON
    @IBAction func placeOrderBtn(_ sender: Any) {        
        if (haveAddressOrNot == true) {
            // Get weather data
            guard let url = URL(string: "https://api.data.gov.sg/v1/environment/2-hour-weather-forecast")
            else { return }
            
            let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(weatherData.self, from: dataResponse)
//                    print(model)
                    
                    let getAmountOfLocationCheck: Int = model.items[0].forecasts!.count
                    print(model.items[0].forecasts![0].area!)
                    for i in 0..<getAmountOfLocationCheck {
                        if (model.items[0].forecasts![i].area == choosenArea) {
                            weatherDetails = model.items[0].forecasts![i].forecast!
                        }
                        
                        else {
                            weatherDetails = ""
                        }
                    }
                }
                
                catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
            task.resume()
            
            // weatherDetails = "Heavy Thundery Showers with Gusty Winds"
                        
            // segue
            if ((weatherDetails.lowercased().contains("rain")) || (weatherDetails.lowercased().contains("thunder")) || (weatherDetails.lowercased().contains("shower")) ) {
                performSegue(withIdentifier: "toOhNo", sender: nil)
            }
            
            else {
                buyProduct()
                insertGameIntoPopularity()
                performSegue(withIdentifier: "toConfirm", sender: nil)
            }
        }
        
        else {
            let alert = UIAlertController(title: "Error", message: "Please choose your address or add your address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressHolder.removeAll()
        
        viewContext = app.persistentContainer.viewContext
            
        orderSummaryTable.separatorStyle = .none
        orderSummaryTable.delegate = self
        orderSummaryTable.dataSource = self
        belowTotalCostLabel.isHidden = true
        
        orderSummaryTableHeightConstraint.constant = orderSummaryTable.contentSize.height
    }
    
    
    
    override func viewWillLayoutSubviews() {
        self.updateViewConstraints()
        orderSummaryTableHeightConstraint.constant = orderSummaryTable.contentSize.height
    }
    

    
    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        let totalCost = defaults.string(forKey: "cartPrice")
        totalCostLabel.text = "Total: \(totalCost!) CR"
        
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
        
        addressHolder.removeAll()
        
        let fetchRequest: NSFetchRequest <Address> = Address.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        do {
            
            let allAddress = try viewContext.fetch(fetchRequest)
            // no address found for user
            if (allAddress.isEmpty) {
                userHaveNoAddressInside = true
                haveAddressOrNot = false
                print("no address at all")
                outputAddressLabel.text = "Please add your address"
                editOrAddBtnStyle.setTitle("Add", for: .normal)
            }
            
            else {
                // check if user has selected a address
                if (doneChoosingAddress != true) {
                    userHaveNoAddressInside = false
                    haveAddressOrNot = false
                    editOrAddBtnStyle.setTitle("Choose", for: .normal)
                    outputAddressLabel.text = "Choose your address"
                }
                
                else {
                    haveAddressOrNot = true
                    userHaveNoAddressInside = false

                    let area = choosenAddress[0]
                    let block = choosenAddress[1]
                    let street = choosenAddress[2]
                    let unit = choosenAddress[3]
                    let postal = choosenAddress[4]
                    let contactNo = choosenAddress[5]
                    choosenArea = choosenAddress[0]
                    
                    outputAddressLabel.text = "\(area)\nBlock \(block), \(street)\n#\(unit)\nSingapore \(postal)\n\(contactNo)"
                    editOrAddBtnStyle.setTitle("Change", for: .normal)
                }
            }
        }
        
        catch {
            print(error)
        }
        
        
        
        
        // show left over user credit
        let fetchRequest2: NSFetchRequest <Login> = Login.fetchRequest()
        let predicate2 = NSPredicate(format: "username like '" + username + "'")
        fetchRequest2.predicate = predicate2
        
        var leftOverCR: Int16!
        
        do {
            let allUser = try viewContext.fetch(fetchRequest2)
            var userCurrentCredit: Int16 = 0
            let totalCost = defaults.string(forKey: "cartPrice")
            
            for user in allUser {
                userCurrentCredit = user.credits
            }
            
            leftOverCR = Int16((Double(userCurrentCredit) - Double(totalCost!)!).rounded(.down))
            leftOverCreditLabel.text = "(You will be left with \(leftOverCR!) CR)"
        }
        
        catch {
            print(error)
        }
    }
    
    
    
    
    // MARK: - EDIT OR ADD BUTTON
    @IBAction func editOrAddBtn(_ sender: Any) {
        if (userHaveNoAddressInside == true) {
            performSegue(withIdentifier: "toAddAddress", sender: nil)
        }
        
        else {
            editAddressComeFromProfile = false
            performSegue(withIdentifier: "toSelectAddress", sender: nil)
        }
    }
    
    
    
    
    // MARK: - SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddAddress") {
            let vc = segue.destination as! EditAddressViewController
            vc.title = "Add Address"
            vc.comingFrom = "order summary"
        }
        
        
        if (segue.identifier == "toOhNo") {
            let vc = segue.destination as! OhNoViewController
            vc.choosenArea = choosenArea
            vc.weatherDetails = weatherDetails
        }
        
        if (segue.identifier == "toConfirm") {
            let vc = segue.destination as! ConfirmViewController
            vc.gameBrought = tempGameStoreForVC
            vc.parcelDeliveryDate = tempDateStoreForVC
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - SHAKE GESTURE
    var counter = 0
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)

        if (counter > 0) {
            let alert = UIAlertController(title: "Error", message: "Looks like you already shake before", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        else {
            counter += 1
            // generate random discount
            let randomInt = Int(arc4random_uniform(20))
            let alert = UIAlertController(title: "Congrats", message: "You have earn \(randomInt)% discount", preferredStyle: .alert)
            alert.addAction((UIAlertAction(title: "Apply", style: .default, handler: { [self] action in
                let totalCost = self.defaults.string(forKey: "cartPrice")
                let convertToDouble = Double(totalCost!)
                let amountToPay = convertToDouble! * ((100.0 - Double(randomInt)) / 100)
                let finalAmount = String(format: "%.2f", amountToPay)
                self.belowTotalCostLabel.isHidden = false
                self.totalCostLabel.text = "Total: \(finalAmount) CR"
                self.belowTotalCostLabel.text = "\(randomInt)% discount applied"
                
                // get amount of credit user have now
                let fetchRequest2: NSFetchRequest <Login> = Login.fetchRequest()
                let predicate2 = NSPredicate(format: "username like '" + username + "'")
                fetchRequest2.predicate = predicate2
                
                var userCurrentCredit: Int16 = 0

                do {
                    let allUser = try viewContext.fetch(fetchRequest2)
                                        
                    for user in allUser {
                        userCurrentCredit = user.credits
                    }
                }
                
                catch {
                    print(error)
                }
                
                print(finalAmount)
                print(userCurrentCredit)
                let calculate: Double = Double(userCurrentCredit) - Double(finalAmount)!
                let roundDownLeftOver = calculate.rounded(.down)
                leftOverCreditLabel.text = "(You will be left with \(Int(roundDownLeftOver)) CR)"

                
                
                defaults.set(finalAmount, forKey: "cartPrice")
            })))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
