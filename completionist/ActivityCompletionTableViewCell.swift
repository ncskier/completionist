//
//  ActivityCompletionTableViewCell.swift
//  completionist
//
//  Created by Brandon Walker on 7/31/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

protocol ActivityCompletionTableViewCellDelegate {
    func activityCompletionTableViewCellSelected(activityCompletionTableViewCell cell: ActivityCompletionTableViewCell)
}

class ActivityCompletionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completionBarView: ActivityCompletionBarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellSelectButton: UIButton!
    
    var delegate: ActivityCompletionTableViewCellDelegate?
    var greenBackgroundColor = UIColor(red: 0.900, green: 1.000, blue: 0.900, alpha: 1.000)
    var grayBackgroundColor = UIColor(red: 0.900, green: 0.900, blue: 0.900, alpha: 1.000)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set up completion bar view
        completionBarView.setupView()
        
        // Setup selected background color to light green
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = greenBackgroundColor
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func loadCell(name name: String, delegate: ActivityCompletionTableViewCellDelegate) {
        
        // Name
        nameLabel.text = name
        
        // Delegate
        self.delegate = delegate
    }
    
    func loadCompletionBar(progress: Float) {
        
        completionBarView.setProgress(progress, animated: true)
        
    }
    
    
    @IBAction func cellSelectButtonTapped(sender: UIButton) {
        
        if (editing) {
            // Edit Cell
            selectedBackgroundView?.backgroundColor = grayBackgroundColor
            if (delegate != nil) {
                // Select Cell for edit
                selectedBackgroundView?.backgroundColor = grayBackgroundColor
                selectedBackgroundView?.backgroundColor = grayBackgroundColor
            }
        } else {
            selectedBackgroundView?.backgroundColor = greenBackgroundColor
            // Select Cell
            selectedBackgroundView?.backgroundColor = greenBackgroundColor
            selectedBackgroundView?.backgroundColor = greenBackgroundColor
        }
        
        delegate?.activityCompletionTableViewCellSelected(activityCompletionTableViewCell: self)
        
    }
    
}
