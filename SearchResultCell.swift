//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Donald Lee on 2015-05-14.
//  Copyright (c) 2015 storesearch. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Called after cell object has been loaded from the nib, but before cell is added to table view
        let selectedView = UIView(frame: CGRect.zeroRect)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255,blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
    
}
