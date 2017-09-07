//
//  RequirementsTableViewCell.swift
//  completionist
//
//  Created by Brandon Walker on 7/21/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit


protocol RequirementsTableViewCellDelegate {
    
    func requirementsTableViewCellDidBeginEditing(requirementsTableViewCell: RequirementsTableViewCell)
    
    func requirementsTableViewCellDidEndEditing(requirementsTableViewCell: RequirementsTableViewCell)
}


class RequirementsTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var requirementsTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var delegate: RequirementsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Assign TextView Delegate
        requirementsTextView.delegate = self
        
        // Set up TextView Margins (so requirements text lines up with activity name)
        requirementsTextView.contentInset.left = -3
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadCell(requirements: String, delegate: RequirementsTableViewCellDelegate?) {
        
        requirementsTextView.text = requirements
        self.delegate = delegate
        
        if (requirements != "") {
            placeholderLabel.isHidden = true
        }
    }
    
    
    // MARK: - TextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (delegate != nil) {
            delegate!.requirementsTableViewCellDidBeginEditing(requirementsTableViewCell: self)
        }
        
        placeholderLabel.isHidden = true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if (textView.text == "") {
            placeholderLabel.isHidden = false
        }
        
        if (delegate != nil) {
            delegate!.requirementsTableViewCellDidEndEditing(requirementsTableViewCell: self)
        }
    }
    
//    func textViewDidChange(textView: UITextView) {
//        
//        if (requirementsTextView.text == "") {
//            placeholderLabel.hidden = false
//        } else {
//            placeholderLabel.hidden = true
//        }
//    }
    
}
