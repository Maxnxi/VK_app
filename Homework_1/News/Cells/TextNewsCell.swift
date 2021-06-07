//
//  TextNewsCell.swift
//  Homework_1
//
//  Created by Maksim on 03.06.2021.
//

import UIKit

class TextNewsCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    static var nibName: String = "TextNewsCell"
    static var reuseIdentifierOfCellNews: String = "textNewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(newsText: String) {
        self.textView.text = newsText
    }
    
}
