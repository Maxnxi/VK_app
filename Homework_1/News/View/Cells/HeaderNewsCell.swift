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
    
    @IBOutlet weak var dateNTimeLbl: UILabel!
    static var nibName: String = "HeaderNewsCell"
    static var reuseIdentifierOfCellNews: String = "headerNewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(authorName: String, authorProfileImgUrl: String, date: Double) {
        self.newsAuthorName.text = authorName
        self.dateNTimeLbl.text = date.fromDoubleToStringDateFormatToCell(date: date)//
        guard let urlString = authorProfileImgUrl as? String else { return }
        let data = try? Data(contentsOf: URL(string: urlString)!)
        guard let image = data else { return }
        self.newsAuthorProfileImg.avatarImage = UIImage(data: image)
    }
}
