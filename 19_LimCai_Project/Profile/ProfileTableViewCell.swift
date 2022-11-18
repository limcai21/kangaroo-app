//
//  ProfileTableViewCell.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 16/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    var iconImage: String?
    let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        let appDelegate = UIApplication.shared.windows.first
        if (sender.isOn) {
            appDelegate?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(true, forKey: "\(username)DarkModeSetting")
        }
        
        else {
            appDelegate?.overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(false, forKey: "\(username)DarkModeSetting")
        }
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
