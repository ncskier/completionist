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
        trackButton = UIButton(type: .custom)
        trackButton.frame = CGRect(x: 0.0, y: view.frame.height-trackButtonHeight, width: view.frame.width, height: trackButtonHeight)
        trackButton.addTarget(self, action: #selector(trackButtonTapped(_:)), for: .touchUpInside)
        trackButton.setTitle("Track", for: UIControlState())
        trackButton.backgroundColor = trackButton.tintColor
        view.addSubview(trackButton)
        
        // Set up tableView
        tableView = UITableView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height-trackButtonHeight), style: .plain
        )
        tableView.contentInset.top = 65.0
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // Register nib
        let activityCompletionNib = UINib(nibName: activityCompletionCellIdentifier, bundle: nil)
        tableView.register(activityCompletionNib, forCellReuseIdentifier: activityCompletionCellIdentifier)
        
        // Add Bar Buttons
        addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        navigationItem.rightBarButtonItem = addBarButton
        
        editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.leftBarButtonItem = editBarButton
        
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        
        // Load Activies from CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            activityList = results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // Check Resetting Activities for new Week
        let todayDate = getNormalizedToday()
        let defaults = UserDefaults.standard
        let lastResetDate = defaults.value(forKey: lastResetDateIdentifier) as? Date
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
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
            let indexPath = IndexPath(item: i, section: 0)
            let cell: ActivityCompletionTableViewCell = tableView.cellForRow(at: indexPath) as! ActivityCompletionTableViewCell
            
            // Load Completion Label
            let numberCompleted = activity.value(forKey: "numberCompleted") as! Int
            let numberGoal = activity.value(forKey: "numberGoal") as! Int
            cell.loadCompletionLabel(numberCompleted: numberCompleted, numberGoal: numberGoal)
            
            // Load Completion Bar
            let progress: Float = Float(numberCompleted) / Float(numberGoal)
            cell.loadCompletionBar(progress)
        }
    }
    
    
    // Week starts on Monday
    func newWeekSince(_ lastDate: Date) -> Bool {
        
        let calendar = Calendar.current
        let normalizedToday = getNormalizedToday()
        
        var todayWeekday = (calendar as NSCalendar).component(.weekday, from: normalizedToday) - 1
        // Start week at Monday
        if (todayWeekday == 0) {
            todayWeekday = 7
        }
        
        let difference = (calendar as NSCalendar).components(.day, from: lastDate, to: normalizedToday, options: [])
        let newWeekEquation = difference.day! + (7 - todayWeekday)   // New Week if >= 7
        
        if ( newWeekEquation >= 7) {
            return true
        }
        
        return false
    }
    
    func getNormalizedToday() -> Date {
        let today = Date()
        let calendar = Calendar.current
        
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: today)
        let normalizedToday = calendar.date(from: components)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get Cell
        let cell: ActivityCompletionTableViewCell = tableView.dequeueReusableCell(withIdentifier: activityCompletionCellIdentifier) as! ActivityCompletionTableViewCell
        
        // Load Cell
        let activity = activityList[indexPath.row]
        let name = activity.value(forKey: "name") as! String
        let numberCompleted = activity.value(forKey: "numberCompleted") as! Int
        let numberGoal = activity.value(forKey: "numberGoal") as! Int
        cell.loadCell(name: name, numberCompleted: numberCompleted, numberGoal: numberGoal, delegate: self)
        
        // Return Cell
        return cell
    }
    
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            // Delete from CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let managedObject = activityList[indexPath.row]
            managedContext.delete(managedObject)
            
            do {
                activityList.remove(at: indexPath.row)
                
                try managedContext.save()
                
            } catch let error as NSError  {
                
                print("Could not save \(error), \(error.userInfo)")
                
            }
            
            tableView.reloadData()
        }
        
    }
    
    
    
    // MARK: - ActivityCompletionTableViewCell Delegate
    
    func activityCompletionTableViewCellSelected(activityCompletionTableViewCell cell: ActivityCompletionTableViewCell) {
        
        if (tableView.isEditing) {
            
            let index = tableView.indexPath(for: cell)!.row
            
            // Create ActivityDetailViewController
            let activityDetailViewController = ActivityDetailViewController()
            activityDetailViewController.activityManagedObject = activityList[index]
            activityDetailViewController.delegate = self
            activityDetailViewController.activityIndex = index
            
            navigationController?.pushViewController(activityDetailViewController, animated: true)
            
        } else {
            
            cell.setSelected(!cell.isSelected, animated: false)
            
        }
    }
    
    
    
    // MARK: - NewActivityViewController Delegate
    
    func newActivityViewController(saveNewActivity newActivity: Activity) {
        
        // Save new activity
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let activityEntity = NSEntityDescription.entity(forEntityName: "Activity", in: managedContext)!
        let managedObject = NSManagedObject(entity: activityEntity, insertInto: managedContext)
        
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.delete(managedObject)
        
        do {
            activityList.remove(at: index)
            
            try managedContext.save()
            
        } catch let error as NSError  {
            
            print("Could not save \(error), \(error.userInfo)")
            
        }
        
        // End editing mode and reload data
        doneButtonTapped(doneBarButton!)
        tableView.reloadData()
    }
    
    
    // MARK: - Button Actions
    
    func addButtonTapped(_ sender: UIBarButtonItem) {
        
        // Display New Activity View Controller modally
        let newActivityViewController = NewActivityViewController()
        newActivityViewController.delegate = self
        
        // Set up navigation controller
        let navigationController = UINavigationController(rootViewController: newActivityViewController)
        
        // Present View Controller
        present(navigationController, animated: true, completion: nil)
    }
    
    func editButtonTapped(_ sender: UIBarButtonItem) {
        
        tableView.setEditing(true, animated: true)
        
        navigationItem.leftBarButtonItem = doneBarButton
        
        // WARNING: Deselect all rows
//        for i in 0..<activityList.count {
//            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! ActivityCompletionTableViewCell
//            cell.deselectCell()
//        }
    }
    
    func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        tableView.setEditing(false, animated: true)
        
        navigationItem.leftBarButtonItem = editBarButton
        
    }
    
    func trackButtonTapped(_ sender: UIButton) {
        
        // Update Activities for selected rows
        var selectedRows = [IndexPath]()
        
        for i in 0..<activityList.count {
            
            let indexPath = IndexPath(item: i, section: 0)
            
            if (tableView.cellForRow(at: indexPath)!.isSelected) {
                selectedRows.append(indexPath)
            }
        }
        
        if (!selectedRows.isEmpty) {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            for indexPath in selectedRows {
                
                let activityManagedObject = activityList[indexPath.row]
                let numberCompleted = activityManagedObject.value(forKey: "numberCompleted") as! Int
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
