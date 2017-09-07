//
//  WeeklyProgressViewController.swift
//  completionist
//
//  Created by Brandon Walker on 7/25/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData

class WeeklyProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    var completionBarCellIdentifier = "CompletionBarTableViewCell"
    
    var activityList: [NSManagedObject]!
    
    var doneBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up tableView
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        // Register Nibs
        let completionBarNib = UINib(nibName: completionBarCellIdentifier, bundle: nil)
        tableView.register(completionBarNib, forCellReuseIdentifier: completionBarCellIdentifier)
        
        // Title
        title = "Weekly Progress"
        
        // Set up Bar Buttons
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancelButtonTapped(_:)))
        navigationItem.leftBarButtonItem = doneBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Load Cells
        for i in 0 ..< activityList.count {
            let indexPath = IndexPath(row: 0, section: i)
            let cell = tableView.cellForRow(at: indexPath) as! CompletionBarTableViewCell
            let activity = activityList[i]
            let percentCompleted: Float = Float(activity.value(forKey: "numberCompleted") as! Int) / Float(activity.value(forKey: "numberGoal") as! Int)
            cell.loadCell(percentCompleted)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    // MARK: - TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return activityList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let activity = activityList[section]
        
        return activity.value(forKey: "name") as? String
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: completionBarCellIdentifier) as! CompletionBarTableViewCell
        
        return cell
    }
    
    
    // MARK: - TableView Delegate
    
    
    
    
    // MARK: - Button Actions
    
    func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
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
