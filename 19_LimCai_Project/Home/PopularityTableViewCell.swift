//
//  PopularityTableViewCell.swift
//  19_LimCai_Project
//
//  Created by xc50c2 on 2022-02-28.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit

class PopularityTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var bg1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
