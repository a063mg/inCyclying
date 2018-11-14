//
//  WelcomeViewController.swift
//  inCyclying
//
//  Created by Alekseev Artem on 02.10.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController{

    @IBAction func getBack(_ sender: Any) {
        print("ok")
      navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
