//
//  Activity.swift
//  completionist
//
//  Created by Brandon Walker on 7/20/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

class Activity: NSObject {
    
    var name: String!
    var requirements: String!
    var numberCompleted: Int = 0
    var numberGoal: Int = 1
    
    override var description: String {
        return "\n\(name)\n\t\(requirements)\n\t\(numberCompleted)/\(numberGoal)"
    }
    
    init(withname name: String, requirements: String, numberGoal: Int, numberCompleted: Int) {
        self.name = name
        self.requirements = requirements
        self.numberGoal = numberGoal
        self.numberCompleted = numberCompleted
    }
    
    // Return text to display as "goalText" (ex: 3/10) for ActivityCheckboxCell
    func goalText() -> String {
        return "\(numberCompleted)/\(numberGoal)"
    }
}
