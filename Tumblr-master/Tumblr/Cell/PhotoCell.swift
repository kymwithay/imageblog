//
//  PhotoCell.swift
//  Tumblr
//
//  Created by Kymberlee Hill on 8/31/18.
//  Copyright © 2018 Kymberlee Hill. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func downloadPhoto(_ sender: Any) {
        
    }
    
}
