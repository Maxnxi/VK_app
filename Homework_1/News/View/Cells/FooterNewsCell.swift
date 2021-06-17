//
//  FooterNewsCell.swift
//  Homework_1
//
//  Created by Maksim on 03.06.2021.
//

import UIKit

class FooterNewsCell: UITableViewCell {

   
    @IBOutlet weak var numOfLikeLbl: UILabel!
    @IBOutlet weak var numOfCommentsLbl: UILabel!
    @IBOutlet weak var smthElseLbl: UILabel!
    
    static var nibName: String = "FooterNewsCell"
    static var reuseIdentifierOfCellNews: String = "footerNewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(numOfLikes: String, numOfComments: String) {
        self.numOfLikeLbl.text = numOfLikes
        self.numOfCommentsLbl.text = numOfComments
    }
    
}
