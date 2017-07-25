//
//  FeedVC.swift
//  SocialMedia
//
//  Created by Sagar Pahlajani on 23/07/17.
//  Copyright © 2017 Sagar Pahlajani. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }

  
    @IBAction func signOutTapped(_ sender: Any) {
        
       let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Sagar: ID Removed from Keychain:\(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }

}
