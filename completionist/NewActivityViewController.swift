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
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        // Register Nibs
        let nameNib = UINib(nibName: nameCellIdentifier, bundle: nil)
        tableView.register(nameNib, forCellReuseIdentifier: nameCellIdentifier)
        
        let requirementsNib = UINib(nibName: requirementsCellIdentifier, bundle: nil)
        tableView.register(requirementsNib, forCellReuseIdentifier: requirementsCellIdentifier)
        
        let goalNib = UINib(nibName: goalCellIdentifier, bundle: nil)
        tableView.register(goalNib, forCellReuseIdentifier: goalCellIdentifier)
        
        // Set up Bar Buttons
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        navigationItem.leftBarButtonItem = cancelBarButton
        
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveBarButton
        
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 1) {
            return "Goal"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                // Name Cell
                let cell: NameTableViewCell = tableView.dequeueReusableCell(withIdentifier: nameCellIdentifier) as! NameTableViewCell
                cell.delegate = self
                cell.nameTextField.becomeFirstResponder()
                
                nameCell = cell
                
                return cell
                
            } else if (indexPath.row == 1) {
                // Requirements Cell
                let cell: RequirementsTableViewCell = tableView.dequeueReusableCell(withIdentifier: requirementsCellIdentifier) as! RequirementsTableViewCell
                cell.delegate = self
                
                requirementsCell = cell
                
                return cell
            }
            
        } else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                // Goal Cell
                let cell = tableView.dequeueReusableCell(withIdentifier: goalCellIdentifier) as! GoalTableViewCell
                
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
    
    func nameTableViewCell(nameTableViewCell: NameTableViewCell, textFieldValueDidChangeTo newValue: String) {
        
        if (newValue == "") {
            title = "New Activity"
        } else {
            title = newValue
        }
    }
    
    func nameTableViewCellDidBeginEditing(nameTableViewCell: NameTableViewCell) {
        
        // Change save button to done button
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func nameTableViewCellDidReturn(nameTableViewCell: NameTableViewCell) {
        
        // Change done button to save button
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    
    // MARK: - RequirementsTableViewCell Delegate
    
    func requirementsTableViewCellDidBeginEditing(requirementsTableViewCell: RequirementsTableViewCell) {
        
        // Change save button to done button
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func requirementsTableViewCellDidEndEditing(requirementsTableViewCell: RequirementsTableViewCell) {
        
        // Change done button to save button
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    
    // MARK: - Button Actions

    func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        let newActivity = Activity(withname: nameCell!.nameTextField.text!, requirements: requirementsCell!.requirementsTextView.text, numberGoal: Int(goalCell!.goalStepper.value), numberCompleted: 0)
        
        if (delegate != nil) {
            delegate!.newActivityViewController(saveNewActivity: newActivity)
        }
        
        // Dismiss View Controller
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonTapped(_ sender: UIBarButtonItem) {
        
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
