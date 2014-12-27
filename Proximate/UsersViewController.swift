//
//  UsersViewController.swift
//  Proximate
//
//  Created by Michael Willis on 14/12/2014.
//  Copyright (c) 2014 Proximate. All rights reserved.
//

import UIKit



class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var images = [NSData]()
    var names = [String]()
    var status = [String]()
    
    
    @IBOutlet weak var appsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     self.appsTableView.delegate = self
     //   self.appsTableView.dataSource = self
        
        //Getting the Users Location Closure
            
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            
            println("works here")
            
          //  if error == nil {
                
                println(geopoint)
                
                var user = PFUser.currentUser()
                
                let userGeoPoint = user["location"] as PFGeoPoint
                
                // Create a query for places
                var query = PFUser.query()
                // Interested in locations near user.
                query.whereKey("location", nearGeoPoint:userGeoPoint)
                // Limit what could be a lot of points.
                query.limit = 10
                // Final list of objects
                
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    
                    self.names.removeAll(keepCapacity: true)
                    self.images.removeAll(keepCapacity: true)
                    
                    for user in users {

                   println(user)
                    
                    if user.username != PFUser.currentUser().username {
                    self.names.append(user.username)
                    self.images.append(user["image"] as NSData)
                //    println(self.names)
                //    println(self.images)
                    }
                }
                //Reload the data
               self.appsTableView.reloadData()
                
            })
             user.save()
     // For IF statement -->> }
    }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
      //  let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")

      let cell = Profiles(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
       cell.nameLabel?.text = "Hello"
     //  cell.textLabel?.text = "hello"
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
        
    }


}
