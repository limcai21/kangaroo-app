//
//  ProductCollectionViewCell.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell  {
    
    @IBOutlet weak var poster: UIImageView!
    
    func setup(game: Products) {
        poster.image = UIImage(named: game.poster)
    }
}
