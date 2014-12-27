//
//  ProfileViewController.swift
//  Proximate
//
//  Created by Michael Willis on 12/12/2014.
//  Copyright (c) 2014 Proximate. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var user = PFUser.currentUser()

    @IBAction func changePicture(sender: UIButton) {
        
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    @IBOutlet weak var profilePic: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var FBSession = PFFacebookUtils.session()
        
        //Accessing FB with the access token.
        var accessToken = FBSession.accessTokenData.accessToken
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        //Creating a Profile Picture from Facebook
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let image = UIImage(data: data)
            
            self.profilePic.image = image
            
            self.user["image"] = data
            
            self.user.save()
            
            FBRequestConnection.startForMeWithCompletionHandler({
                connection, result, error in
                
                self.user["gender"] = result["gender"]
                self.user["name"] = result["name"]
                
                self.user.save()
                
                println(result)
                
                
            })
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        println("image selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        profilePic.image = image
        
        
        
        var updateImage = PFUser.currentUser()
        
        let imageData = UIImagePNGRepresentation(self.profilePic.image)
        let image = PFFile(name: "image.png", data: imageData)
        updateImage["image"] = image
        updateImage.save()
        
        println("Image Uploaded to server")
        
        //Now needs saving to the persistant storage (core data) ==============================================================================
        
    }
    
    //Add a new User Function (ADD THIS TO THE VIEW DID LOAD TO ADD MORE USERS)
    func addPerson(urlString:String) {
        
        var i = 30
        var newUser = PFUser()
        
        let url = NSURL(string: urlString)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        //Makes a connection with the URL request.
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            newUser["image"] = data
            
            newUser["gender"] = "female"
            
            var lat = Double(37 + i)
            
            var lon = Double(-122 + i)
            
            i = i + 10
            
            var location = PFGeoPoint(latitude: lat, longitude: lon)
            
            newUser["location"] = location
            
            newUser.username = "\(i)"
            
            newUser.password = "password"
            
            newUser.signUp()
        })
    }
    //Add New User Here for testing.
    // addPerson("https://www.google.co.uk/search?q=david+beckham&rlz=1C5CHFA_enGB567GB568&espv=2&biw=1440&bih=801&source=lnms&tbm=isch&sa=X&ei=Cd-NVInfE4bwUtKtg-gF&ved=0CAYQ_AUoAQ#facrc=_&imgdii=_&imgrc=56vq8l2uYtkzLM%253A%3BKeJKlnxqFOgK9M%3Bhttp%253A%252F%252Fstatic2.stuff.co.nz%252F1402448260%252F942%252F10144942.jpg%3Bhttp%253A%252F%252Fwww.stuff.co.nz%252Fsport%252Ffootball%252F10144939%252FDavid-Beckham-MLS-bid-suffers-Miami-setback%3B360%3B433")

}
