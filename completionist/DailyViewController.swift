//
//  DailyViewController.swift
//  completionist
//
//  Created by Brandon Walker on 7/20/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit
import CoreData

class DailyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewActivityViewControllerDelegate, ActivityDetailViewControllerDelegate, ActivityCompletionTableViewCellDelegate {

//    @IBOutlet weak var tableView: UITableView!
    var tableView: UITableView!
    
    var trackButton: UIButton!
    var addBarButton: UIBarButtonItem!
    var editBarButton: UIBarButtonItem!
    var doneBarButton: UIBarButtonItem!
    
    let lastResetDateIdentifier = "lastResetDate"
    let activityCompletionCellIdentifier = "ActivityCompletionTableViewCell"
    var activityList = [NSManagedObject]()
    
    
    // GOAL: USE Fetched Results Controller for CoreData !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set title
        title = "Daily Checklist"
        
        // Set up track button
        let trackButtonHeight: CGFloat = 55.0
        trackButton = UIButton(type: .Custom)
        trackButton.frame = CGRect(x: 0.0, y: view.frame.height-trackButtonHeight, width: view.frame.width, height: trackButtonHeight)
        trackButton.addTarget(self, action: #selector(trackButtonTapped(_:)), forControlEvents: .TouchUpInside)
        trackButton.setTitle("Track", forState: .Normal)
        trackButton.backgroundColor = trackButton.tintColor
        view.addSubview(trackButton)
        
        // Set up tableView
        tableView = UITableView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height-trackButtonHeight), style: .Plain
        )
        tableView.contentInset.top = 65.0
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // Register nib
        let activityCompletionNib = UINib(nibName: activityCompletionCellIdentifier, bundle: nil)
        tableView.registerNib(activityCompletionNib, forCellReuseIdentifier: activityCompletionCellIdentifier)
        
        // Add Bar Buttons
        addBarButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addButtonTapped(_:)))
        navigationItem.rightBarButtonItem = addBarButton
        
        editBarButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.leftBarButtonItem = editBarButton
        
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneButtonTapped(_:)))
        
        // Load Activies from CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            activityList = results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // Check Resetting Activities for new Week
        let todayDate = getNormalizedToday()
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastResetDate = defaults.valueForKey(lastResetDateIdentifier) as? NSDate
        
        if (lastResetDate == nil) {
            // Set today as last reset date
            defaults.setValue(todayDate, forKey: lastResetDateIdentifier)
        } else {
            // Check if it's a new week since last reset date
            if ( newWeekSince(lastResetDate!) ) {
                
                resetActivities()
                defaults.setValue(todayDate, forKey: lastResetDateIdentifier)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        animateReloadCompletionCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func animateReloadCompletionCells() {
        // Animate loading completion cells
        for i in 0..<activityList.count {
            // Important Vars
            let activity = activityList[i]
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let cell: ActivityCompletionTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! ActivityCompletionTableViewCell
            
            // Load Completion Label
            let numberCompleted = activity.valueForKey("numberCompleted") as! Int
            let numberGoal = activity.valueForKey("numberGoal") as! Int
            cell.loadCompletionLabel(numberCompleted: numberCompleted, numberGoal: numberGoal)
            
            // Load Completion Bar
            let progress: Float = Float(numberCompleted) / Float(numberGoal)
            cell.loadCompletionBar(progress)
        }
    }
    
    
    // Week starts on Monday
    func newWeekSince(lastDate: NSDate) -> Bool {
        
        let calendar = NSCalendar.currentCalendar()
        let normalizedToday = getNormalizedToday()
        
        var todayWeekday = calendar.component(.Weekday, fromDate: normalizedToday) - 1
        // Start week at Monday
        if (todayWeekday == 0) {
            todayWeekday = 7
        }
        
        let difference = calendar.components(.Day, fromDate: lastDate, toDate: normalizedToday, options: [])
        let newWeekEquation = difference.day + (7 - todayWeekday)   // New Week if >= 7
        
        if ( newWeekEquation >= 7) {
            return true
        }
        
        return false
    }
    
    func getNormalizedToday() -> NSDate {
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day, .Month, .Year], fromDate: today)
        let normalizedToday = calendar.dateFromComponents(components)
        
        return normalizedToday!
    }
    
    // Reset Acitivity numberCompleted
    func resetActivities() {
        
        for activity in activityList {
            // Reset Activity numberCompleted
            
            activity.setValue(0, forKey: "numberCompleted")
        }
        
    }
    
    
    // MARK: - TableView Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get Cell
        let cell: ActivityCompletionTableViewCell = tableView.dequeueReusableCellWithIdentifier(activityCompletionCellIdentifier) as! ActivityCompletionTableViewCell
        
        // Load Cell
        let activity = activityList[indexPath.row]
        let name = activity.valueForKey("name") as! String
        let numberCompleted = activity.valueForKey("numberCompleted") as! Int
        let numberGoal = activity.valueForKey("numberGoal") as! Int
        cell.loadCell(name: name, numberCompleted: numberCompleted, numberGoal: numberGoal, delegate: self)
        
        // Return Cell
        return cell
    }
    
    
    // MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableView.editing
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == .Delete) {
            // Delete from CoreData
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let managedObject = activityList[indexPath.row]
            managedContext.deleteObject(managedObject)
            
            do {
                activityList.removeAtIndex(indexPath.row)
                
                try managedContext.save()
                
            } catch let error as NSError  {
                
                print("Could not save \(error), \(error.userInfo)")
                
            }
            
            tableView.reloadData()
        }
        
    }
    
    
    
    // MARK: - ActivityCompletionTableViewCell Delegate
    
    func activityCompletionTableViewCellSelected(activityCompletionTableViewCell cell: ActivityCompletionTableViewCell) {
        
        if (tableView.editing) {
            
            let index = tableView.indexPathForCell(cell)!.row
            
            // Create ActivityDetailViewController
            let activityDetailViewController = ActivityDetailViewController()
            activityDetailViewController.activityManagedObject = activityList[index]
            activityDetailViewController.delegate = self
            activityDetailViewController.activityIndex = index
            
            navigationController?.pushViewController(activityDetailViewController, animated: true)
            
        } else {
            
            cell.setSelected(!cell.selected, animated: false)
            
        }
    }
    
    
    
    // MARK: - NewActivityViewController Delegate
    
    func newActivityViewController(saveNewActivity newActivity: Activity) {
        
        // Save new activity
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let activityEntity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedContext)!
        let managedObject = NSManagedObject(entity: activityEntity, insertIntoManagedObjectContext: managedContext)
        
        managedObject.setValue(newActivity.name, forKey: "name")
        managedObject.setValue(newActivity.requirements, forKey: "requirements")
        managedObject.setValue(newActivity.numberGoal, forKey: "numberGoal")
        managedObject.setValue(newActivity.numberCompleted, forKey: "numberCompleted")
        
        do {
            try managedContext.save()
            
            activityList.append(managedObject)
            
        } catch let error as NSError  {
            
            print("Could not save \(error), \(error.userInfo)")
            
        }
        
        // End editing mode and reload data
        doneButtonTapped(doneBarButton!)
        tableView.reloadData()
    }
    
    
    // MARK: - ActivityDetailViewController Delegate
    
    func activityDetailViewController(updateActivity activity: Activity, forManagedObject activityManagedObject: NSManagedObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        activityManagedObject.setValue(activity.name, forKey: "name")
        activityManagedObject.setValue(activity.requirements, forKey: "requirements")
        activityManagedObject.setValue(activity.numberGoal, forKey: "numberGoal")
        activityManagedObject.setValue(activity.numberCompleted, forKey: "numberCompleted")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            
            print("Could not save \(error), \(error.userInfo)")
            
        }
        
        // End editing mode and relaod data
        doneButtonTapped(doneBarButton!)
        tableView.reloadData()
    }
    
    func activityDetailViewController(deleteActivityWithManagedObject managedObject: NSManagedObject, atIndex index: Int) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.deleteObject(managedObject)
        
        do {
            activityList.removeAtIndex(index)
            
            try managedContext.save()
            
        } catch let error as NSError  {
            
            print("Could not save \(error), \(error.userInfo)")
            
        }
        
        // End editing mode and reload data
        doneButtonTapped(doneBarButton!)
        tableView.reloadData()
    }
    
    
    // MARK: - Button Actions
    
    func addButtonTapped(sender: UIBarButtonItem) {
        
        // Display New Activity View Controller modally
        let newActivityViewController = NewActivityViewController()
        newActivityViewController.delegate = self
        
        // Set up navigation controller
        let navigationController = UINavigationController(rootViewController: newActivityViewController)
        
        // Present View Controller
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func editButtonTapped(sender: UIBarButtonItem) {
        
        tableView.setEditing(true, animated: true)
        
        navigationItem.leftBarButtonItem = doneBarButton
        
        // WARNING: Deselect all rows
//        for i in 0..<activityList.count {
//            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! ActivityCompletionTableViewCell
//            cell.deselectCell()
//        }
    }
    
    func doneButtonTapped(sender: UIBarButtonItem) {
        
        tableView.setEditing(false, animated: true)
        
        navigationItem.leftBarButtonItem = editBarButton
        
    }
    
    func trackButtonTapped(sender: UIButton) {
        
        // Update Activities for selected rows
        var selectedRows = [NSIndexPath]()
        
        for i in 0..<activityList.count {
            
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            
            if (tableView.cellForRowAtIndexPath(indexPath)!.selected) {
                selectedRows.append(indexPath)
            }
        }
        
        if (!selectedRows.isEmpty) {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            for indexPath in selectedRows {
                
                let activityManagedObject = activityList[indexPath.row]
                let numberCompleted = activityManagedObject.valueForKey("numberCompleted") as! Int
                activityManagedObject.setValue(numberCompleted + 1, forKey: "numberCompleted")
            }
            
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                
                print("Could not save \(error), \(error.userInfo)")
                
            }
            
            tableView.reloadData()
            
            animateReloadCompletionCells()
            
        }
        
        // Show new view controller
        
//        let weeklyProgressViewController = WeeklyProgressViewController()
//        weeklyProgressViewController.activityList = activityList
        
//        let weeklyNavigationController = UINavigationController(rootViewController: weeklyProgressViewController)
        
//        presentViewController(weeklyNavigationController, animated: true, completion: nil)
    }



//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
    
    
    

}
