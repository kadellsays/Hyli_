//
//  SideMenuCell.swift
//  HyLi
//
//  Created by Kadell on 3/1/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ label:SideMenuLabel) {
        menuImage.image = label.image.withRenderingMode(.alwaysTemplate)
        menuImage.tintColor = UIColor.black
        menuName.text = label.name
    }

}
