//
//  ActivityCheckboxTableViewCell.swift
//  completionist
//
//  Created by Brandon Walker on 7/20/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

protocol ActivityCheckboxTableViewCellDelegate {
    func activityCheckboxTableViewCellSelectedForDetailEdit(_ activityCheckboxTableViewCell: ActivityCheckboxTableViewCell)
}

class ActivityCheckboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var requirementsTextView: UITextView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var cellSelectButton: UIButton!
    
    var delegate: ActivityCheckboxTableViewCellDelegate?
    var greenBackgroundColor = UIColor(red: 0.900, green: 1.000, blue: 0.900, alpha: 1.000)
    var grayBackgroundColor = UIColor(red: 0.900, green: 0.900, blue: 0.900, alpha: 1.000)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Setup requirements textView
        requirementsTextView.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 1, right: 1)
        
        // Setup selected background color to light green
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = greenBackgroundColor
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadCell(name: String, requirements: String, numberCompleted: Int, numberGoal: Int, delegate: ActivityCheckboxTableViewCellDelegate?) {
        nameLabel.text = name
        requirementsTextView.text = requirements
        goalLabel.text = "\(numberCompleted)/\(numberGoal)"
        self.delegate = delegate
        
        // Select checkbox is cell selected
        checkboxButton.isSelected = isSelected
        
        // Turn goalText green if complete
        if (numberCompleted >= numberGoal) {
            goalLabel.textColor = UIColor(red: 0.041, green: 0.920, blue: 0.000, alpha: 1.00)
        } else {
            goalLabel.textColor = UIColor.black
        }
    }
    
    func deselectCell() {
        // Uncheck box and set selected to false
        setSelected(false, animated: false)
        checkboxButton.isSelected = false
    }
    
    // MARK: - IBActions
    
    // Doesn't do anything now with cellSelectButton (I also disconnected it in IB)
//    @IBAction func checkboxTapped(sender: CheckboxButton) {
//        
//        checkboxButton.selected = !checkboxButton.selected
//        
//    }
    
    @IBAction func cellSelectButtonTapped(_ sender: UIButton) {
        
        if (isEditing) {
            // Edit Cell
            if (delegate != nil) {
                // Select Cell for edit
                setSelected(!isSelected, animated: false)
                selectedBackgroundView?.backgroundColor = grayBackgroundColor
                delegate!.activityCheckboxTableViewCellSelectedForDetailEdit(self)
            }
        } else {
            // Select Cell
            selectedBackgroundView?.backgroundColor = greenBackgroundColor
            checkboxButton.isSelected = !checkboxButton.isSelected
            setSelected(!isSelected, animated: false)
        }
        
    }
    
}
