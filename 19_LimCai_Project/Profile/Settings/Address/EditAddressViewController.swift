//
//  EditAddressViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 16/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

var locationArray = [String]()


class EditAddressViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var actionBtnStyle: UIButton!
    @IBOutlet weak var chooseThisAddressStyle: UIButton!
    
    @IBOutlet weak var areaLiveInLabel: UITextField!
    @IBOutlet weak var blockLabel: UITextField!
    @IBOutlet weak var streetLabel: UITextField!
    @IBOutlet weak var housingUnitLabel: UITextField!
    @IBOutlet weak var postalLabel: UITextField!
    @IBOutlet weak var contactNoLabel: UITextField!
    
    
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
    
    
    
    var area = ""
    var block = ""
    var unit = ""
    var street = ""
    var postal: Int64!
    var contactNo: Int64!
    
    var originalDataArray = [[String]]()
    
    var comingFrom: String!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
    
    var locationCount = 0
    
    

    
    // MARK: - UIPICKER FOR AREA LIVE IN
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        areaLiveInLabel.text = locationArray[row]
    }
    
    
    
    
    
    // MARK: - ADD ADRESS FUNCTION
    func addAddress() {
        // check if database got this same address
        let fetchRequest: NSFetchRequest <Address> = Address.fetchRequest()
        let predicate1: NSPredicate = NSPredicate(format: "area like '" + areaLiveInLabel.text! + "'")
        let predicate2: NSPredicate = NSPredicate(format: "block like '" + blockLabel.text! + "'")
        let predicate3: NSPredicate = NSPredicate(format: "street like '" + streetLabel.text! + "'")
        let predicate4: NSPredicate = NSPredicate(format: "unit like '" + housingUnitLabel.text! + "'")
        let predicate5: NSPredicate = NSPredicate(format: "contactNo like '" + contactNoLabel.text! + "'")
        let predicate6: NSPredicate = NSPredicate(format: "postalCode like '" + postalLabel.text! + "'")
        let predicate7: NSPredicate = NSPredicate(format: "username like '" + username + "'")
        let predicate: NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4, predicate5, predicate6, predicate7] )
        fetchRequest.predicate = predicate
        
        
        do {
            let allAddress = try viewContext.fetch(fetchRequest)
            
            if (allAddress.isEmpty) {
                let address = NSEntityDescription.insertNewObject(forEntityName: "Address", into: viewContext) as! Address
                address.area = areaLiveInLabel.text
                address.block = blockLabel.text
                address.street = streetLabel.text
                address.unit = housingUnitLabel.text
                address.postalCode = Int64(postalLabel.text!)!
                address.contactNo = Int64(contactNoLabel.text!)!
                address.username = username
                
                app.saveContext()
                
                let alert = UIAlertController(title: "Completed", message: "Your address has been added", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                    doneChoosingAddress = false
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            
            else {
                let alert = UIAlertController(title: "Error", message: "You have already added this address", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        catch {
            print(error)
        }
    }
    
    
    // MARK: - CHOOSEN THIS ADDRESS BUTTON
    @IBAction func chooseThisAddressBtn(_ sender: Any) {
        let fetchRequest: NSFetchRequest <Address> = Address.fetchRequest()
        let predicate1: NSPredicate = NSPredicate(format: "area like '" + areaLiveInLabel.text! + "'")
        let predicate2: NSPredicate = NSPredicate(format: "block like '" + blockLabel.text! + "'")
        let predicate3: NSPredicate = NSPredicate(format: "street like '" + streetLabel.text! + "'")
        let predicate4: NSPredicate = NSPredicate(format: "unit like '" + housingUnitLabel.text! + "'")
        let predicate5: NSPredicate = NSPredicate(format: "contactNo like '" + contactNoLabel.text! + "'")
        let predicate6: NSPredicate = NSPredicate(format: "postalCode like '" + postalLabel.text! + "'")
        let predicate7: NSPredicate = NSPredicate(format: "username like '" + username + "'")
        let predicate: NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4, predicate5, predicate6, predicate7] )
        fetchRequest.predicate = predicate

        do {
            let allAddress = try viewContext.fetch(fetchRequest)
        
            if (allAddress.isEmpty) {
                let alert = UIAlertController(title: "Error", message: "Please update your address before choosing it as your shipping address", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            else {
                doneChoosingAddress = true
                
                choosenAddress.removeAll()
                choosenAddress.append(contentsOf: [areaLiveInLabel.text!, blockLabel.text!, streetLabel.text!, housingUnitLabel.text!, postalLabel.text!, contactNoLabel.text!])
                
                let alert = UIAlertController(title: "Completed", message: "Your address has been choosen", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableAddress"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
        
        catch {
            print(error)
        }
    }
    
    
    
    
    // MARK: - UPDATE ADDRESS FUNCTION
    func updateAddress() {
        // update
        // originalDataArray.append([area, block, street, unit, String(postal), String(contactNo)])
        let fetchRequest: NSFetchRequest <Address> = Address.fetchRequest()
        let predicate1: NSPredicate = NSPredicate(format: "area like '" + areaLiveInLabel.text! + "'")
        let predicate2: NSPredicate = NSPredicate(format: "block like '" + blockLabel.text! + "'")
        let predicate3: NSPredicate = NSPredicate(format: "street like '" + streetLabel.text! + "'")
        let predicate4: NSPredicate = NSPredicate(format: "unit like '" + housingUnitLabel.text! + "'")
        let predicate5: NSPredicate = NSPredicate(format: "contactNo like '" + contactNoLabel.text! + "'")
        let predicate6: NSPredicate = NSPredicate(format: "postalCode like '" + postalLabel.text! + "'")
        let predicate7: NSPredicate = NSPredicate(format: "username like '" + username + "'")
        let predicate: NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4, predicate5, predicate6, predicate7] )
        fetchRequest.predicate = predicate
        
        
        do {
            let allAddress = try viewContext.fetch(fetchRequest)
            
            if (!allAddress.isEmpty) {
                let alert = UIAlertController(title: "Error", message: "Your address is currently the same. Please update if need to", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Don't Need", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            
            else {
                // update orignal data
                
                let fetchRequest: NSFetchRequest <Address> = Address.fetchRequest()
                let predicate1: NSPredicate = NSPredicate(format: "area like '" + originalDataArray[0][0] + "'")
                let predicate2: NSPredicate = NSPredicate(format: "block like '" + originalDataArray[0][1] + "'")
                let predicate3: NSPredicate = NSPredicate(format: "street like '" + originalDataArray[0][2] + "'")
                let predicate4: NSPredicate = NSPredicate(format: "unit like '" + originalDataArray[0][3] + "'")
                let predicate5: NSPredicate = NSPredicate(format: "contactNo like '" + originalDataArray[0][5] + "'")
                let predicate6: NSPredicate = NSPredicate(format: "postalCode like '" + originalDataArray[0][4] + "'")
                let predicate7: NSPredicate = NSPredicate(format: "username like '" + username + "'")
                let predicate: NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4, predicate5, predicate6, predicate7] )
                fetchRequest.predicate = predicate
                
                do {
                    let allAddress = try viewContext.fetch(fetchRequest)
                
                    for address in allAddress {
                        address.area =  areaLiveInLabel.text!
                        address.block = blockLabel.text!
                        address.street = streetLabel.text!
                        address.unit = housingUnitLabel.text!
                        address.contactNo = Int64(contactNoLabel.text!)!
                        address.postalCode = Int64(postalLabel.text!)!
                        address.username = username
                        
                        app.saveContext()
                    }
                    
                    if (editAddressComeFromProfile == true) {
                        let alert = UIAlertController(title: "Completed", message: "Address updated!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableAddress"), object: nil)
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true)
                    }
                    
                    else {
                        let alert = UIAlertController(title: "Completed", message: "Address updated!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableAddress"), object: nil)
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
        }

        catch {
            print(error)
        }
    }
    
    
    
    // MARK: - ACTION BUTTON
    @IBAction func actionBtn(_ sender: Any) {
        if (areaLiveInLabel.text == "" || blockLabel.text == "" || streetLabel.text == "" || housingUnitLabel.text == "" || postalLabel.text == "" || contactNoLabel.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        else {
            if (Int64(postalLabel.text!) != nil) {
                if (Int64(contactNoLabel.text!) != nil) {
                    if (comingFrom == "order summary" || comingFrom == "from plus") {
                        addAddress()
                    }
                    
                    if (comingFrom == "your address") {
                        // update
                        updateAddress()
                    }
                }
                
                else {
                    let alert = UIAlertController(title: "Error", message: "Contact Number has to be a number", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            else {
                let alert = UIAlertController(title: "Error", message: "Postal Code has to be a number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    
    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        let pickerView = UIPickerView()
        
        areaLiveInLabel.inputView = pickerView
        areaLiveInLabel.resignFirstResponder()
        areaLiveInLabel.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Get weather locations
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
                print(model)
                self.locationCount = model.items[0].forecasts!.count
                print(self.locationCount)
                locationArray.removeAll()
                for i in 0..<self.locationCount {
                    print(model.items[0].forecasts![i].area!)
                    locationArray.append(model.items[0].forecasts![i].area!)
                }
                print(locationArray)

            }
            
            catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        task.resume()
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseThisAddressStyle.layer.borderColor = UIColor.label.cgColor
        chooseThisAddressStyle.layer.borderWidth = 2
        
        print(locationArray)
        
        
        
        chooseThisAddressStyle.isHidden = false
        
        self.hideKeyboardWHenTappedAround()
        
        viewContext = app.persistentContainer.viewContext

        areaLiveInLabel.addBottomBorderLineWithColor(width: 2)
        blockLabel.addBottomBorderLineWithColor(width: 2)
        streetLabel.addBottomBorderLineWithColor(width: 2)
        housingUnitLabel.addBottomBorderLineWithColor(width: 2)
        postalLabel.addBottomBorderLineWithColor(width: 2)
        contactNoLabel.addBottomBorderLineWithColor(width: 2)
        
        
        
        if (userHaveNoAddressInside) {
            chooseThisAddressStyle.isHidden = true
        }
        
        else {
            chooseThisAddressStyle.isHidden = false
            actionBtnStyle.setTitle("Update", for: .normal)
            
            
            // from select address to here
            if (comingFrom == "from plus" || comingFrom == "order summary") {
                chooseThisAddressStyle.isHidden = true
                actionBtnStyle.setTitle("Add Address", for: .normal)
            }
            
            else {
                // output database address and edit address
                if (comingFrom == "your address") {
                    areaLiveInLabel.text = area
                    blockLabel.text = block
                    streetLabel.text = street
                    housingUnitLabel.text = unit
                    postalLabel.text = String(postal)
                    contactNoLabel.text = String(contactNo)
                    
                    originalDataArray.removeAll()
                    originalDataArray.append([area, block, street, unit, String(postal), String(contactNo)])
                    
                    print(originalDataArray)
                    
                    if (editAddressComeFromProfile) {
                        chooseThisAddressStyle.isHidden = true
                        actionBtnStyle.isHidden = false
                        actionBtnStyle.backgroundColor = UIColor.label
                    }
                    
                    else {
                        chooseThisAddressStyle.isEnabled = true
                    }
                }
            }
        }
    }
}