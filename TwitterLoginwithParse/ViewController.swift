//
//  ViewController.swift
//  TwitterLoginwithParse
//
//  Created by StrawBerry on 10.06.2015.
//  Copyright (c) 2015 StrawBerry. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loginSetup()
    }
    

    
    func loginSetup(){
        if(PFUser.currentUser() == nil)
        {
            var logInViewController = PFLogInViewController()
            
            logInViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.Twitter
            
            //TODO: We're removing the default logo in the Login page. We put there to create a custom label.
            
            var logInLogoTitle = UILabel()
            logInLogoTitle.text = "Login Logo";
            
            logInViewController.logInView!.logo = logInLogoTitle
            
            logInViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            
            //TODO: We're removing the default logo in the Sign up page. We put there to create a custom label.

            var signUpLogoTitle = UILabel()
            signUpLogoTitle.text = "Sign Up Logo";
            
            signUpViewController.signUpView!.logo = signUpLogoTitle
            
            signUpViewController.delegate = self
            
            logInViewController.signUpController = signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
        }

    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
        
        self.loginSetup()
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if(!username.isEmpty || !password.isEmpty)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
   /* func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        /*var uEmail:String = info["email"] as! String
        var uID:String = info["username"] as! String
        var uPwd:String = info["password"] as! String
        
        if(!uID.isEmpty || !uPwd.isEmpty || !uEmail.isEmpty){
        return false
        }
        else{
        return false
        }
        */
    }
   */
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        if(PFTwitterUtils.isLinkedWithUser(user)){
            
            signUpController.fields = PFSignUpFields.UsernameAndPassword | PFSignUpFields.Email | PFSignUpFields.allZeros | PFSignUpFields.DismissButton | PFSignUpFields.SignUpButton
            var twitterUsername = PFTwitterUtils.twitter()?.screenName
            
            PFUser.currentUser()?.username = twitterUsername
            PFUser.currentUser()?.saveEventually(nil)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Failed to login...")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User dismissed sign up...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

