//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by eiji on 2015/05/18.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

/**
An extended table view cell class with an erase button.
If the eraseButton is active, this cell data can be removed from the parent table view.
*/
class MemeTableViewCell: UITableViewCell {
	
	@IBOutlet weak var eraseButton: UISwitch!
	
}