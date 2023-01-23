//
//  StockTableViewCell.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastUpdateTime: UILabel!
    
    @IBOutlet weak var columnOne: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var columnTwo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.name.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
