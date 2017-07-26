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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            //print(snapshot.value as Any)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for snap in snapshot {
                    //print("Snap: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any>
                    {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("Sagar: \(post.caption)")
        
        return UITableViewCell()
    }

  
    @IBAction func signOutTapped(_ sender: Any) {
        
       let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Sagar: ID Removed from Keychain:\(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }

}
