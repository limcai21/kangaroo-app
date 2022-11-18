//
//  ConfirmViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 24/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class ConfirmViewController: UIViewController {

    @IBOutlet weak var parcelDeliveryLabel: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    var gameBrought: String?
    var parcelDeliveryDate = ""
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
    
    var comingFrom = ""
    
    
    // MARK: - HOME BUTTON
    @IBAction func homtBtn(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    // MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let totalCost = UserDefaults.standard.string(forKey: "cartPrice")
        
        viewContext = app.persistentContainer.viewContext
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        thankYouLabel.text = gameBrought!
        parcelDeliveryLabel.text = parcelDeliveryDate
        totalCostLabel.text = "\(totalCost!) CR"
    }
}
