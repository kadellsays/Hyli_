//
//  SuggestionTableViewCell.swift
//  HyLi
//
//  Created by Kadell on 11/10/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import UIKit
import SDWebImage

class SuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var suggestionImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var moneySignOne: UIImageView!
    @IBOutlet weak var moneySignTwo: UIImageView!
    @IBOutlet weak var moneySignThree: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none   
    }
    
    
    func configureCell(currentSuggestion: Suggestions, cell: SuggestionTableViewCell) {
        let city = currentSuggestion.locality
        let name = currentSuggestion.venue_name
        let price = currentSuggestion.price
        let type = currentSuggestion.type
        let summary = currentSuggestion.description
        let distance = currentSuggestion.distance
        let urlString = currentSuggestion.photo
        
        
        cell.label.text = name

        
        let fillerImage = UIImage(named: "hyliFiller")
        cell.suggestionImage.sd_setImage(with: URL(string: urlString), placeholderImage: fillerImage, options: [.continueInBackground,.highPriority], completed: nil)


        
    }
    
    override func prepareForReuse() {
    }

}
