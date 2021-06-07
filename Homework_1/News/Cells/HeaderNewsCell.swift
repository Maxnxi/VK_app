//
//  HeaderNewsCell.swift
//  Homework_1
//
//  Created by Maksim on 03.06.2021.
//

import UIKit

class HeaderNewsCell: UITableViewCell {

    @IBOutlet weak var newsAuthorName: UILabel!
    @IBOutlet weak var newsAuthorProfileImg: AvatarView!
    
    static var nibName: String = "HeaderNewsCell"
    static var reuseIdentifierOfCellNews: String = "headerNewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(authorName: String, authorProfileImgUrl: String) {
        self.newsAuthorName.text = authorName
        
        guard let urlString = authorProfileImgUrl as? String else { return }
        let data = try? Data(contentsOf: URL(string: urlString)!)
        guard let image = data else { return }
        self.newsAuthorProfileImg.avatarImage = UIImage(data: image)
    }
    
}
