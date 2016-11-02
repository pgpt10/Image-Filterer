//
//  FilterTypeCollectionViewCell.swift
//  Filterer
//
//  Created by Payal Gupta on 10/31/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import UIKit

class FilterTypeCollectionViewCell: UICollectionViewCell
{
    //MARK: Outlets
    @IBOutlet weak var filterTypeImageView: UIImageView!
    @IBOutlet weak var filterTypeLabel: UILabel!
    
    //MARK: Lifecycle Methods
    override func awakeFromNib()
    {
        self.filterTypeImageView.image = nil
        self.filterTypeLabel.text = nil
    }
    
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.backgroundColor = UIColor.lightGray
            }
            else
            {
                self.backgroundColor = UIColor.groupTableViewBackground
            }
        }
    }
}
