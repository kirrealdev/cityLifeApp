//
//  ImageViewCell.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {
    
    
    @IBOutlet weak var customImageView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        customImageView.image = UIImage(named: "customImage")
        customImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
