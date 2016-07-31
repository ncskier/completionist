//
//  NewActivityViewController.swift
//  completionist
//
//  Created by Brandon Walker on 7/21/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData


protocol NewActivityViewControllerDelegate {
    
    func newActivityViewController(saveNewActivity newActivity: Activity)
}


class NewActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NameTableViewCellDelegate, RequirementsTableViewCellDelegate {
    
    var tableView: UITableView!
    
    let nameCellIdentifier = "NameTableViewCell"
    let requirementsCellIdentifier = "RequirementsTableViewCell"
    let goalCellIdentifier = "GoalTableViewCell"
    
    var nameCell: NameTableViewCell?
    var requirementsCell: RequirementsTableViewCell?
    var goalCell: GoalTableViewCell?
    
    var cancelBarButton: UIBarButtonItem?
    var saveBarButton: UIBarButtonItem?
    var doneBarButton: UIBarButtonItem?
    
    var delegate: NewActivityViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up title
        title = "New Activity"
        
        // Set up tableView
        tableView = UITableView(frame: view.frame, style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // Register Nibs
        let nameNib = UINib(nibName: nameCellIdentifier, bundle: nil)
        tableView.registerNib(nameNib, forCellReuseIdentifier: nameCellIdentifier)
        
        let requirementsNib = UINib(nibName: requirementsCellIdentifier, bundle: nil)
        tableView.registerNib(requirementsNib, forCellReuseIdentifier: requirementsCellIdentifier)
        
        let goalNib = UINib(nibName: goalCellIdentifier, bundle: nil)
        tableView.registerNib(goalNib, forCellReuseIdentifier: goalCellIdentifier)
        
        // Set up Bar Buttons
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        navigationItem.leftBarButtonItem = cancelBarButton
        
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveBarButton
        
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneButtonTapped(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                // Name Cell
                return 46
            } else if (indexPath.row == 1) {
                // Requirements Cell
                return 100
            }
        } else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                // Goal Cell
                return 50
            }
        }
        
        // Should never get to here
        return 44
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 1) {
            return "Goal"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                // Name Cell
                let cell: NameTableViewCell = tableView.dequeueReusableCellWithIdentifier(nameCellIdentifier) as! NameTableViewCell
                cell.delegate = self
                cell.nameTextField.becomeFirstResponder()
                
                nameCell = cell
                
                return cell
                
            } else if (indexPath.row == 1) {
                // Requirements Cell
                let cell: RequirementsTableViewCell = tableView.dequeueReusableCellWithIdentifier(requirementsCellIdentifier) as! RequirementsTableViewCell
                cell.delegate = self
                
                requirementsCell = cell
                
                return cell
            }
            
        } else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                // Goal Cell
                let cell = tableView.dequeueReusableCellWithIdentifier(goalCellIdentifier) as! GoalTableViewCell
                
                goalCell = cell
                
                return cell
            }
            
        }
        
        // This code should never execute - only here to get rid of warning
        print("ERROR loading cells for new Activity")
        return UITableViewCell()
    }
    
    
    // MARK: - UITableView Delegate
    
    
    
    // MARK: - NameTableViewCell Delegate
    
    func nameTableViewCell(nameTableViewCell nameTableViewCell: NameTableViewCell, textFieldValueDidChangeTo newValue: String) {
        
        if (newValue == "") {
            title = "New Activity"
        } else {
            title = newValue
        }
    }
    
    func nameTableViewCellDidBeginEditing(nameTableViewCell nameTableViewCell: NameTableViewCell) {
        
        // Change save button to done button
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func nameTableViewCellDidReturn(nameTableViewCell nameTableViewCell: NameTableViewCell) {
        
        // Change done button to save button
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    
    // MARK: - RequirementsTableViewCell Delegate
    
    func requirementsTableViewCellDidBeginEditing(requirementsTableViewCell requirementsTableViewCell: RequirementsTableViewCell) {
        
        // Change save button to done button
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func requirementsTableViewCellDidEndEditing(requirementsTableViewCell requirementsTableViewCell: RequirementsTableViewCell) {
        
        // Change done button to save button
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    
    // MARK: - Button Actions

    func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveButtonTapped(sender: UIBarButtonItem) {
        
        let newActivity = Activity(withname: nameCell!.nameTextField.text!, requirements: requirementsCell!.requirementsTextView.text, numberGoal: Int(goalCell!.goalStepper.value), numberCompleted: 0)
        
        if (delegate != nil) {
            delegate!.newActivityViewController(saveNewActivity: newActivity)
        }
        
        // Dismiss View Controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneButtonTapped(sender: UIBarButtonItem) {
        
        // Dismiss keyboard
        view.endEditing(true)
        
        // Change back to Save button
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
