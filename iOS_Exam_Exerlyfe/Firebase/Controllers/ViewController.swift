//
//  ViewController.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 18/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FBSDKLoginKit //Import the fb login kit

class ViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var profilePicture: UIImageView! //profile pic image
    
    @IBOutlet weak var continueButton: UIButton! //the continue button, should be hidden when not logged in.
    
   var fbUserId = ""
    
    
    let fbMan = FirebaseManager() //instance of firebasemanager class
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialize the login button and add it to the view
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.delegate = self //assign delegate, to make the login button funcs work
        
        //Hide continue button initially
        continueButton.isHidden = true
        
        //Calling funcs
        makeProfilePicRound()
        
        //Default avatar
        profilePicture.image = #imageLiteral(resourceName: "defaultavatar")
        
        //Checks if user is already logged in
        if let token = AccessToken.current,
            !token.isExpired {
            fbUserId = AccessToken.current!.userID
            // User is logged in, set profile pic.
            profilePicture.image = getProfPic(fid: fbUserId)
            //continue button visible
            continueButton.isHidden = false
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "vcToChoice", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destinationVC = segue.destination as! ChoiceTableViewController //casting and force unwrap cause I know it's there.
        destinationVC.retrieveUserId = fbUserId //passing fb user id.
    }
    
    
    //What to do when logged in
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        fbUserId = AccessToken.current!.userID //get user id.
        
        //Set profile pic to users profile pic on log in
        profilePicture.image = getProfPic(fid: AccessToken.current!.userID)
        
        continueButton.isHidden = false
    }
    
    //What to do when logged out
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //Default avatar again on logout
        profilePicture.image = #imageLiteral(resourceName: "defaultavatar")
        
        continueButton.isHidden = true //Hide it on logout
    }
    
    //Function to fetch users profile picture from their user id.
  func getProfPic(fid: String) -> UIImage? {
        if (fid != "") { //if facebook id is not empty
            
            //Get the profilepicture downloaded from facebook graph with provided ID
            let imgURLString = "https://graph.facebook.com/" + fid + "/picture?type=large&redirect=true&width=500&height=500"
            
            //Save the url as NSURL
            let imgURL = NSURL(string: imgURLString)
            //Get the data from the NSURL imgURL
            let imageData = NSData(contentsOf: imgURL! as URL)
            //Set it to a UIImage with the imageData.
            let image = UIImage(data: imageData! as Data)
            
            
            return image //return it.
        }
        return nil //Returns nil if no facebook ID is provided.
    }
    
    fileprivate func makeProfilePicRound() { //makes profile picture round
          //Hidden initially
          profilePicture.layer.borderWidth = 5
          profilePicture.layer.masksToBounds = false
          profilePicture.layer.borderColor = #colorLiteral(red: 0.1585051715, green: 0.6766349673, blue: 0.7152240276, alpha: 1)
          profilePicture.layer.cornerRadius = profilePicture.frame.height/2
          profilePicture.clipsToBounds = true
      }



}

