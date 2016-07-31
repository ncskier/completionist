//
//  DeleteTableViewCell.swift
//  completionist
//
//  Created by Brandon Walker on 7/23/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

protocol DeleteTableViewCellDelegate {
    func deleteTableViewCellTapped(deleteTableViewCell deleteTableViewCell: DeleteTableViewCell)
}

class DeleteTableViewCell: UITableViewCell {
    
    var delegate: DeleteTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - IBActions
    
    @IBAction func deleteButtonTapped(sender: UIButton) {
        
        if (delegate != nil) {
            delegate!.deleteTableViewCellTapped(deleteTableViewCell: self)
        }
        
    }
    
}
