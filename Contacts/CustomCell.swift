//
//  CustomCell.swift
//  DNET
//
//  Created by AndroidDev on 01/08/2017.
//  Copyright © 2017 ESCO Phil. Inc. All rights reserved.
//

import UIKit
class CustomCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var contact: UILabel!
    
    var onButtonTapped : (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func btnSelectedItem(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
            
        }
    }
}

