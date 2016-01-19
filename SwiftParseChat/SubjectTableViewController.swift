//
//  SubjectTableViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/9/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

/* Brian's Key Changes:
- Comment out all references to 'GroupSelectTableViewControllerDelegate'
- Add new String var to store desired Parse class
*/

// Test 2

import UIKit

class SubjectTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    var subjects: NSArray!
    var courses: NSArray!
//    var delegate: GroupSelectTableViewControllerDelegate!
    var selectedSubject: NSDictionary!
    
    var filteredSubjects: NSArray!
    var searchController: UISearchController!
    var parseClassString: String!
    
//    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = NSBundle.mainBundle().pathForResource("courses", ofType: "json") {
            if let jsonData = NSData.dataWithContentsOfMappedFile(path) as? NSData {
                let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.subjects = jsonResult.objectForKey("subjects") as! NSArray!
            }
        }
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true;
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.active {
            return self.filteredSubjects.count
        }
        return self.subjects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Return FILTERED results when searchController (ie search bar) is active
        if self.searchController.active {
            if let subject = self.filteredSubjects[indexPath.row] as? NSDictionary {
                if let subjectCode = subject["code"] as? String {
                    cell.textLabel?.text = subjectCode
                }
                if let subjectDesc = subject["desc"] as? String {
                    cell.detailTextLabel?.text = subjectDesc
                }
            }
        }
          
        // Return UNFILTERED results when searchController (ie search bar) is not in use
        else {
            if let subject = self.subjects[indexPath.row] as? NSDictionary {
                if let subjectCode = subject["code"] as? String {
                    cell.textLabel?.text = subjectCode
                }
                if let subjectDesc = subject["desc"] as? String {
                    cell.detailTextLabel?.text = subjectDesc
                }
            }
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.searchController.active {
            if let subject = self.filteredSubjects[indexPath.row] as? NSDictionary {
                print(subject)
                if let courses = subject["courses"] as? NSArray {
                    self.selectedSubject = subject
                    self.courses = courses
                    self.performSegueWithIdentifier("subjectToCourseSegue", sender: self)
                }
            }
        }
        else {
            if let subject = self.subjects[indexPath.row] as? NSDictionary {
                if let courses = subject["courses"] as? NSArray {
                    self.selectedSubject = subject
                    self.courses = courses
                    self.performSegueWithIdentifier("subjectToCourseSegue", sender: self)
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "subjectToCourseSegue" {
            let courseVC = segue.destinationViewController as! CourseTableViewController
//            courseVC.delegate = self.delegate
            courseVC.subject = self.selectedSubject
            courseVC.courses = self.courses
        }
    }
    
    // MARK: - UISearchControllerDelegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        let predicate = NSPredicate(format: "code contains[c] %@ OR desc contains[c] %@", argumentArray: [searchString!, searchString!])
        self.filteredSubjects = self.subjects.filteredArrayUsingPredicate(predicate)
        
        self.tableView.reloadData()
    }

}
