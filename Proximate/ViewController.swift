//
//  ViewController.swift
//  Proximate
//
//  Created by Michael Willis on 12/12/2014.
//  Copyright (c) 2014 Proximate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func loginButton(sender: UIButton) {
        
        var permissions = ["public_profile"]
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                
                
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                
                self.performSegueWithIdentifier("logedIn", sender: self)
                
            } else {
                NSLog("User logged in through Facebook!")
                
                self.performSegueWithIdentifier("logedIn", sender: self)
            }
            
        })
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

