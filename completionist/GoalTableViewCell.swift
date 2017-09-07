//
//  GoalTableViewCell.swift
//  completionist
//
//  Created by Brandon Walker on 7/21/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Setup Stepper
        goalStepper.minimumValue = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadCell(numberGoal: Int) {
        goalStepper.value = Double(numberGoal)
        goalLabel.text = "\(numberGoal)"
    }
    
    
    // MARK: - IBActions
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        goalLabel.text = "\(Int(goalStepper.value))"
    }
    
}
