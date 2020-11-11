//
//  BasicInfoViewCell.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import UIKit

class BasicInfoViewCell: UITableViewCell {

    @IBOutlet weak var firstBasicParameterLabel: UILabel!
    @IBOutlet weak var secondBasicParameterLabel: UILabel!
    @IBOutlet weak var firstBasicParameterValueLabel: UILabel!
    @IBOutlet weak var secondBasicParameterValueLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
