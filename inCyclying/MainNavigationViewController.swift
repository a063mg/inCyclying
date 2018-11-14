//
//  MainNavigationViewController.swift
//  inCyclying
//
//  Created by Alekseev Artem on 02.10.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var isLaunched: Bool = false
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            isLaunched = false
        }
        else{
            isLaunched = true
        }
        
        isLaunched = true
//        defaults.set("No", forKey:"isFirstTime")
//        defaults.synchronize()
        
        if isLaunched{
            perform(#selector(showHomeController), with: nil, afterDelay: 0.01)
        }
        else{
            perform(#selector(showWelcomeController), with: nil, afterDelay: 0.01)
        }
        
    }
    
    @objc func showWelcomeController(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "navigationController") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //show window
        appDelegate.window?.rootViewController = view
    }
    
    @objc func showHomeController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "tabBarController") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //show window
        appDelegate.window?.rootViewController = view
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
