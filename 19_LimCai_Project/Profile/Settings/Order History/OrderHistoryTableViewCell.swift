//
//  OrderHistoryTableViewCell.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 24/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var gamePoster: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gamePrice: UILabel!
    @IBOutlet weak var gameQuantity: UILabel!
    @IBOutlet weak var broughtOnLabel: UILabel!
    
    
    @IBOutlet weak var xbo: UIButton!
    @IBOutlet weak var xbs: UIButton!
    @IBOutlet weak var ps4: UIButton!
    @IBOutlet weak var ps5: UIButton!
    
    
    func setup(game: Array<Any>) {
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
        
        
        let selectedPlatform = game[2] as! String
        
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
        
        gameQuantity.text = "x\((game[3] as? String)!)"
        gamePoster.image = UIImage(named: game[4] as! String)
        
        let doublePrice = Double((game[1] as? String)!)!
        let totalQuantity = Double((game[3] as? String)!)!
        let gamePriceForCalculate = doublePrice * totalQuantity

        let doubleStr = String(format: "%.2f", gamePriceForCalculate)

        gamePrice.text = "\(doubleStr) CR"
        
        broughtOnLabel.text = game[5] as? String

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
