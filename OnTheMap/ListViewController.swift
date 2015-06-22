//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 21/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit

class ListViewController: StudentLocationsViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var studentLocations = [StudentLocation]()

    override func loadedLocations(locations: [StudentLocation]) {
        super.loadedLocations(locations)
        studentLocations = locations
        tableView.reloadData()
    }

    @IBAction func dropPinButtonClicked(sender: AnyObject) {
        println("poink!")
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationViewCell") as! UITableViewCell

        let studentLocation = studentLocations[indexPath.item]

        if let
            firstName = studentLocation.firstName,
            lastName = studentLocation.lastName {
            cell.textLabel!.text = "\(firstName) \(lastName)"
        } else {
            cell.textLabel!.text = "anonymous"
        }

        if let mapString = studentLocation.mapString {
            cell.detailTextLabel!.text = mapString
        } else {
            cell.detailTextLabel!.text = ""
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    @IBAction func findOnTheMap(segue:UIStoryboardSegue) {
        println("ListViewController.findOnTheMap")
    }
    
}
