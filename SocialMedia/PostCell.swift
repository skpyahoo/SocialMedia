//
//  PostCell.swift
//  SocialMedia
//
//  Created by Sagar Pahlajani on 23/07/17.
//  Copyright © 2017 Sagar Pahlajani. All rights reserved.
//

import UIKit

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
    
    func configureCell(post: Post)
    {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        
    }

   

}
