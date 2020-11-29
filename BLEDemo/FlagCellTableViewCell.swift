//
//  FlagCellTableViewCell.swift
//  BLEDemo
//
//  Created by Duaa alharbi 1607217 - Doaa altawil 0932785
//

import UIKit

class FlagCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeStampLable: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Prepares the receiver for service after it has been loaded from an Interface
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //Configure the view for the selected state
    }

}
