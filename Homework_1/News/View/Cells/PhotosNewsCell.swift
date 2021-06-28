//
//  PhotosNewsCell.swift
//  Homework_1
//
//  Created by Maksim on 03.06.2021.
//

// REFACTORING IN PROCCESS !!!!!!!!!!

import UIKit

class PhotosNewsCell: UITableViewCell {

    //private let imagesViewArr: [UIImageView] = [UIImageView(),UIImageView(),UIImageView(),UIImageView()]
    
    static let nibName: String = "PhotosNewsCell"
    static let reuseIdentifierOfCellNews: String = "photosNewsCell"
    
    private let newsImageView: UIImageView = {
     let newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return newsImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingCell()
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
    }
    
    //настройка ячейки
    func configureCell(image: String) {
        newsImageView.loadImage(imageUrlString: image)
    }

    private func settingCell() {
            
            contentView.addSubview(newsImageView)
            
        let topConstraint = newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            newsImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        topConstraint.priority = .init(999)
    }
}

