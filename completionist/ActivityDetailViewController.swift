//
//  ActivityDetailViewController.swift
//  completionist
//
//  Created by Brandon Walker on 7/23/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData

protocol ActivityDetailViewControllerDelegate {
    func activityDetailViewController(updateActivity activity: Activity, forManagedObject activityManagedObject: NSManagedObject)
    
    func activityDetailViewController(deleteActivityWithManagedObject managedObject: NSManagedObject, atIndex index: Int)
}

class ActivityDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NameTableViewCellDelegate, RequirementsTableViewCellDelegate, DeleteTableViewCellDelegate {
    
    var tableView: UITableView!
    var nameCell: NameTableViewCell?
    var requirementsCell: RequirementsTableViewCell?
    var goalCell: GoalTableViewCell?
    var completedToGoalCell: CompletedToGoalTableViewCell?
    var deleteCell: DeleteTableViewCell?
    
    let nameCellIdentifier = "NameTableViewCell"
    let requirementsCellIdentifier = "RequirementsTableViewCell"
    let goalCellIdentifier = "GoalTableViewCell"
    let completedToGoalCellIdentifier = "CompletedToGoalTableViewCell"
    let deleteCellIdentifier = "DeleteTableViewCell"
    
    var activityManagedObject: NSManagedObject!
    var delegate: ActivityDetailViewControllerDelegate?
    var activityIndex: Int?
    var deleteActivity = false
    var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up Table View
        tableView = UITableView(frame: view.frame, style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // Register Nibs
        let nameNib = UINib(nibName: nameCellIdentifier, bundle: nil)
        tableView.registerNib(nameNib, forCellReuseIdentifier: nameCellIdentifier)
        
        let requirementsNib = UINib(nibName: requirementsCellIdentifier, bundle: nil)
        tableView.registerNib(requirementsNib, forCellReuseIdentifier: requirementsCellIdentifier)
        
        let goalNib = UINib(nibName: goalCellIdentifier, bundle: nil)
        tableView.registerNib(goalNib, forCellReuseIdentifier: goalCellIdentifier)
        
        let completedToGoalNib = UINib(nibName: completedToGoalCellIdentifier, bundle: nil)
        tableView.registerNib(completedToGoalNib, forCellReuseIdentifier: completedToGoalCellIdentifier)
        
        let deleteNib = UINib(nibName: deleteCellIdentifier, bundle: nil)
        tableView.registerNib(deleteNib, forCellReuseIdentifier: deleteCellIdentifier)
        
        // Set Title to name
        title = activityManagedObject.valueForKey("name") as? String
        
        // Create done bar button
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneButtonTapped(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
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
        } else if (indexPath.section == 2) {
            
            if (indexPath.row == 0) {
                // Delete Cell
                return 46
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
                cell.loadCell(name: activityManagedObject.valueForKey("name") as? String, delegate: self)
                
                nameCell = cell
                
                return cell
                
            } else if (indexPath.row == 1) {
                // Requirements Cell
                let cell: RequirementsTableViewCell = tableView.dequeueReusableCellWithIdentifier(requirementsCellIdentifier) as! RequirementsTableViewCell
                cell.loadCell(requirements: activityManagedObject.valueForKey("requirements") as! String, delegate: self)
                
                requirementsCell = cell
                
                return cell
            }
            
        } else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                // CompletedToGoal Cell
                let cell = tableView.dequeueReusableCellWithIdentifier(completedToGoalCellIdentifier) as! CompletedToGoalTableViewCell
                cell.loadCell(numberCompleted: activityManagedObject.valueForKey("numberCompleted") as! Int, numberGoal: activityManagedObject.valueForKey("numberGoal") as! Int)
                
                completedToGoalCell = cell
                
                return cell
            }
            
        } else if (indexPath.section == 2) {
            
            if (indexPath.row == 0) {
                // Delete Cell
                let cell = tableView.dequeueReusableCellWithIdentifier(deleteCellIdentifier) as! DeleteTableViewCell
                cell.delegate = self
                
                deleteCell = cell
                
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
        
        // Set title to new name
        title = newValue
    }
    
    func nameTableViewCellDidBeginEditing(nameTableViewCell nameTableViewCell: NameTableViewCell) {
        
        // Show doneBarButton
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func nameTableViewCellDidReturn(nameTableViewCell nameTableViewCell: NameTableViewCell) {
        
        // Remove done button
        navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - RequirementsTableViewCell Delegate
    
    func requirementsTableViewCellDidBeginEditing(requirementsTableViewCell requirementsTableViewCell: RequirementsTableViewCell) {
        
        // Show doneBarButton
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func requirementsTableViewCellDidEndEditing(requirementsTableViewCell requirementsTableViewCell: RequirementsTableViewCell) {
        
        // Remove done bar button
        navigationItem.rightBarButtonItem = nil
    }
    
    
    // MARK: - DeleteTableViewCell Delegate
    
    func deleteTableViewCellTapped(deleteTableViewCell deleteTableViewCell: DeleteTableViewCell) {
        
        // Create alertView to confirm deletion
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
            if (self.delegate != nil) {
                self.delegate!.activityDetailViewController(deleteActivityWithManagedObject: self.activityManagedObject, atIndex: self.activityIndex!)
                self.deleteActivity = true
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Button Actions
    
    func doneButtonTapped(sender: UIBarButtonItem) {
        
        // Hide Keyboard
        view.endEditing(true)
        
        // Remove done button
        navigationItem.rightBarButtonItem = nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillDisappear(animated: Bool) {
        
        if (!deleteActivity) {
            // Update and Save Managed Object
            let activity = Activity(withname: nameCell!.nameTextField.text!, requirements: requirementsCell!.requirementsTextView.text, numberGoal: Int(completedToGoalCell!.goalStepper.value), numberCompleted: Int(completedToGoalCell!.completedStepper.value))
            
            if (delegate != nil) {
                delegate?.activityDetailViewController(updateActivity: activity, forManagedObject: activityManagedObject)
            }
        }
    }

}
