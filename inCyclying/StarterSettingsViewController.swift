//
//  StarterSettingsViewController.swift
//  inCyclying
//
//  Created by Alekseev Artem on 03.10.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit

class StarterSettingsViewController: UITableViewController{
    
    @IBOutlet var tableview: UITableView!
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableview.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func viewDidLoad() {
    }
    

    
}
