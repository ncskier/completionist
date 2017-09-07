//
//  CompletedToGoalTableViewCell.swift
//  completionist
//
//  Created by Brandon Walker on 7/24/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

class CompletedToGoalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completedStepper: UIStepper!
    @IBOutlet weak var goalStepper: UIStepper!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set stepper minimum values
        goalStepper.minimumValue = 1.0
        completedStepper.minimumValue = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCell(numberCompleted: Int, numberGoal: Int) {
        
        completedStepper.value = Double(numberCompleted)
        completedLabel.text = "\(numberCompleted)"
        
        goalStepper.value = Double(numberGoal)
        goalLabel.text = "\(numberGoal)"
    }
    
    
    // MARK: - IBActions
    
    @IBAction func completedStepperValueChanged(_ sender: UIStepper) {
        
        // Update Completed Label
        completedLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func goalStepperValueChanged(_ sender: UIStepper) {
        
        // Update Goal Label
        goalLabel.text = "\(Int(sender.value))"
    }
    
}
