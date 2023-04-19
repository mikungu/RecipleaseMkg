//
//  PresentTableViewCell.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import UIKit

class PresentTableViewCell: UITableViewCell {
    
    //MARK: -Outlets
    
    @IBOutlet weak var imageViewCell: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: -Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelAccessibility()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: -Methods
    func labelAccessibility () {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityHint = " recipe title "
        
        subTitleLabel.isAccessibilityElement = true
        subTitleLabel.accessibilityHint = " ingredients list of the recipe "
        
        noteLabel.isAccessibilityElement = true
        noteLabel.accessibilityHint = " the note that has the recipe so far "
        
        timeLabel.isAccessibilityElement = true
        timeLabel.accessibilityHint = " the indicative time of cooking "
    }
    
    func configure (recipe: Recipe) {
        imageViewCell.downloaded(from: recipe.image)
        titleLabel.text = recipe.label
        var strIngredient = ""
        recipe.ingredientLines.forEach { ingredient in strIngredient = strIngredient + " " + ingredient }
        subTitleLabel.text = strIngredient
        noteLabel.text = "\(recipe.yield)"
        timeLabel.text = "\(recipe.totalTime ?? 0)"
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        load(url: url)
    }
}
