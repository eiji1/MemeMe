//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by eiji on 2015/05/11.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

/**
An extended collection view cell including an image view and an erase button.
If the eraseButton is active, this cell data can be removed from the collection view.
*/
class MemeCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var memeImageView: UIImageView!
	@IBOutlet weak var eraseButton: UISwitch!
	
}
