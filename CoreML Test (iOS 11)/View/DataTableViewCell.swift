//
//  DataTableViewCell.swift
//  CoreML Test (iOS 11)
//
//  Created by Jeane Carlos on 8/10/17.
//  Copyright © 2017 jisy. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var guessText: UILabel!
    @IBOutlet weak var confidenceText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
