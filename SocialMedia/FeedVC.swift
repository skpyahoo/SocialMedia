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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageAdd: CircleView!
    @IBOutlet var captionField: FancyField!
    
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCahce: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
        {
            
            if let img = FeedVC.imageCahce.object(forKey: post.imageUrl as NSString)
            {
                cell.configureCell(post: post, img: img)
                return cell
            }
            else
            {
                cell.configureCell(post: post)
                return cell
            }

        }
        else
        {
        
        return PostCell()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imageAdd.image = image
            imageSelected = true
        }
        else
        {
            print("Sagar: A valid image wasn't selected")
        }

        
        imagePicker.dismiss(animated: true, completion: nil)
    }

  
    @IBAction func signOutTapped(_ sender: Any) {
        
       let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Sagar: ID Removed from Keychain:\(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    

    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            print("Sagar: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("Sagar: Image must be entered")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2)
        {
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metaData, completion: { (metaData, error) in
                
                if error != nil
                {
                    print("Sagar: Unable to upload images to firebase Storage")
                }
                else
                {
                    print("Image uploaded to Firebase sucessfully")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL
                    {
                    self.postToFirebase(imgUrl: url)
                    }
                }
                
            
            
            
            
            })
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, Any> = [
        "caption": captionField.text!,
        "imageUrl": imgUrl,
        "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        tableView.reloadData()
    }
    
}

