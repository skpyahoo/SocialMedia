//
//  CircleView.swift
//  SocialMedia
//
//  Created by Sagar Pahlajani on 23/07/17.
//  Copyright © 2017 Sagar Pahlajani. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
        
    
    
    

}
