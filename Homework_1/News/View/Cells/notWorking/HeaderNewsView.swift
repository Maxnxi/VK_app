//
//  HeaderNewsView.swift
//  Homework_1
//
//  Created by Maksim on 07.06.2021.
//

import UIKit
import Foundation

class HeaderNewsView: UIView {

    var authorName: String?
    var authorProfileAvatar: AvatarView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func awakeFromNib() {
        setupView()
        
            
    }
        
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

    func configureView(avatarImg: String, authorName: String) {
        self.authorName = authorName
        
        guard let urlString = avatarImg as? String,
              let urlData = URL(string: urlString) as? URL else { return }
        let data = try? Data(contentsOf: urlData)
        
        guard let image = data else { return }
        
        authorProfileAvatar?.avatarImage = UIImage(data: image)
        
    }
    
    func setupView(_ frame: CGRect = CGRect(x: 50 , y: 50, width: 200, height: 40)){
      
        //self.inputView?.frame.origin.x
        
        let rect = frame
        let headerView = UIView(frame: rect)
        headerView.backgroundColor = .yellow
        
        let rectForAvatar = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imageProfileAuthor = AvatarView(frame: rectForAvatar)
        imageProfileAuthor.backgroundColor = .green
        imageProfileAuthor.imageView.image = UIImage(named: "profile")

        let nameAuthorLbl = UILabel()
        nameAuthorLbl.text = self.authorName
        
        headerView.addSubview(imageProfileAuthor)
        headerView.addSubview(nameAuthorLbl)
        
        imageProfileAuthor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageProfileAuthor.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0),
            imageProfileAuthor.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            imageProfileAuthor.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 12)
        ])
        
        nameAuthorLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameAuthorLbl.leftAnchor.constraint(equalTo: imageProfileAuthor.rightAnchor, constant: 12),
            nameAuthorLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0)
        ])
    }
}
