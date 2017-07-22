//
//  SignInVC.swift
//  SocialMedia
//
//  Created by Sagar Pahlajani on 20/07/17.
//  Copyright © 2017 Sagar Pahlajani. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet var emailField: FancyField!

    @IBOutlet var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbBtnPressed(_ sender: Any) {
        
        let fbLogin = FBSDKLoginManager()
        
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
        
            if error != nil
            {
                print("Sagar: Unable to authenticate with Facebook- \(String(describing: error))")
            } else if result?.isCancelled == true
            {
                print("Sagar: User cancelled Facebook authentication")
            }
            else
            {
                print("Sagar: Successfully authenticated with FB!!👍")
                let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credentials)
            }
        
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential)
    {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
        
            if error != nil
            {
                print("Sagar: Unable to authenticate wth Firebase - \(String(describing: error))")
            }
            else
            {
                print("Sagar: Successfully authenticated with Firebase")
            }
        
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text
        {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
            
                if error == nil{
                    print("Sagar: Successfully Sign in with email to the Firebase")
                }
                else
                {
                    print("Sagar: user doen't exist.Create one")
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    
                        if error != nil
                        {
                            print("Sagar: Unable to authenticate wth Firebase using email")
                        }
                        else
                        {
                            print("Sagar: Successfully authenticated with Firebase for new user creation")
                        }

                        
                    
                    })
                    
                }
                
            
            })
        }
    }
    

}

