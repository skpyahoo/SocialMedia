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
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   

}
