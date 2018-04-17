//
//  SelectionTableViewCell.swift
//  HyLi
//
//  Created by Kadell on 9/19/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {


    @IBOutlet weak var checkedImage: UIImageView!
    @IBOutlet weak var selectionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none   
    }

}
