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
import SwiftKeychainWrapper


class SignInVC: UIViewController {
    
    @IBOutlet var emailField: FancyField!

    @IBOutlet var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID)
        {
            print("Sagar: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                
                if let user = user
                {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: (user.uid), userData: userData)
                }
                
            }
        
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text
        {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
            
                if error == nil{
                    print("Sagar: Successfully Sign in with email to the Firebase")
                    if let user = user
                    {
                     let userData = ["provider": user.providerID]
                     self.completeSignIn(id: (user.uid), userData: userData)
                    }
                    
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
                            if let user = user
                            {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: (user.uid), userData: userData)
                            }
                            
                        }

                        
                    
                    })
                    
                }
                
            
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>)
    {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
       let key = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Sagar: Succefully got Login UID:\(key)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    

}

