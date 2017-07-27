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
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil)
    {
        self.post = post
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
    }

   

}
