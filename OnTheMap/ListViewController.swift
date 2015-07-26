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
    var studentLocations = [StudentInformation]()

    override func loadedLocations(locations: [StudentInformation]) {
        super.loadedLocations(locations)
        studentLocations = locations
        tableView.reloadData()
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

        if let mediaURL = studentLocation.mediaURL {
            cell.detailTextLabel!.text = mediaURL
        } else {
            cell.detailTextLabel!.text = ""
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let studentLocation = studentLocations[indexPath.item]
        if let urlString = studentLocation.mediaURL,
            url = NSURL(string: urlString)
            where UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
        }
    }

}
