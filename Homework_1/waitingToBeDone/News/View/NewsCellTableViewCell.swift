//
//  NewsCellTableViewCell.swift
//  Homework_1
//
//  Created by Maksim on 18.03.2021.
//

import UIKit

class NewsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsAuthorAvatarView: AvatarView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var shareImg: UIImageView!
    @IBOutlet weak var counterOfSeenLbl: UILabel!
    @IBOutlet weak var counterOfLikeLbl: UILabel!
    @IBOutlet weak var counterOfComments: UILabel!
    @IBOutlet weak var likeControlView: LikeControlView!
    
    static var nibName: String = "NewsCellTableViewCell"
    static var reuseIdentifierOfCellNews: String = "NewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
              
    func configureView(news: News) {
        self.newsAuthor.text = news.newsAuthorFullName
        self.newsDate.text = news.newsDate
        self.newsAuthorAvatarView.avatarImage = news.newsAuthorAvatarView//UIImage(named: news.newsAuthorAvatarView) ?? UIImage(named: "emptyProfileImage")
        //newsAuthorAvatarView.configureView(nameOfImage: news.newsAuthorAvatarView)
        newsAuthorAvatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsAuthorAvatarView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            newsAuthorAvatarView.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        ])
        self.newsLabel.text = news.newsLabel
        self.newImageView.image = UIImage(named: news.newImage)
        self.counterOfSeenLbl.text = "Просмотрено: \(news.counterOfSeen)"
        self.counterOfLikeLbl.text = "Понравилось: \(news.counterOfLike)"
        self.counterOfComments.text = "Комментариев: \(news.counterOfComments)"
        
        let rect = CGRect(x: 0, y: 0, width: likeControlView.frame.size.width, height: likeControlView.frame.size.height)
        likeControlView.configureView(rectangleToDisplay: rect, numOflikes: news.counterOfLike)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
