//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 21/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dropPinButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a refresh button (because we can't add buttons programatically)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshButtonClicked")
        refreshButton.tintColor = .blackColor()

        navigationItem.rightBarButtonItems = [refreshButton, dropPinButton]
    }

    func refreshButtonClicked() {
        println("refreshing!")
    }

    @IBAction func dropPinButtonClicked(sender: AnyObject) {
        println("poink!")
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationViewCell") as! UITableViewCell

        cell.textLabel!.text = "Hello"

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
