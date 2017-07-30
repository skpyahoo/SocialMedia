//
//  PostCell.swift
//  SocialMedia
//
//  Created by Sagar Pahlajani on 23/07/17.
//  Copyright © 2017 Sagar Pahlajani. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet var likesLbl: UILabel!
    @IBOutlet var postImg: UIImageView!
    @IBOutlet var profileImg: CircleView!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var caption: UITextView!
    @IBOutlet var likeImage: UIImageView!
    
    var post: Post!
    var likesRef: DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil)
    {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil
        {
            self.postImg.image = img
        }
        else
        {
            
                let ref = Storage.storage().reference(forURL: post.imageUrl)
            
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                    if error != nil
                    {
                        print("Sagar: Unbale to download image from Firebase Storage")
                    }
                    else
                    {
                        print("Sagar: Imgae downloaded Successfully")
                        if let imgData = data
                        {
                            if let img = UIImage(data: imgData)
                            {
                                self.postImg.image = img
                                FeedVC.imageCahce.setObject(img, forKey: post.imageUrl as NSString)
                            }
                        }
                    }
                
                })
            
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
            if let _ = snapshot.value as? NSNull
            {
                self.likeImage.image = UIImage(named: "empty-heart")
            }
            else
            {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
            
        
        
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer)
    {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull
            {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                
            }
            else
            {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
            
            
            
        })
        
    }

   

}
