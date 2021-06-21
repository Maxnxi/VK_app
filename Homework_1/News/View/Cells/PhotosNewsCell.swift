//
//  PhotosNewsCell.swift
//  Homework_1
//
//  Created by Maksim on 03.06.2021.
//

// REFACTORING IN PROCCESS !!!!!!!!!!

import UIKit

class PhotosNewsCell: UITableViewCell {

    private var imagesViewArr: [UIImageView] = []
    private var imagesArr: [UIImage] = []
    
    static let nibName: String = "PhotosNewsCell"
    static let reuseIdentifierOfCellNews: String = "photosNewsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagesViewArr.map({$0.image = nil})
    }
    
    //настройка ячейки
    func configureCell(imagesArr: [UIImage]?) {
        self.imagesArr = imagesArr ?? []
    }

    private func settingCell() {
        //to do - to think how optimize
        
        
        for i in 0..<imagesArr.count {
            imagesViewArr.append(UIImageView(image: imagesArr[i]))
        }
        
        for number in 0..<imagesViewArr.count{
            contentView.addSubview(imagesViewArr[number])
            imagesViewArr[number].translatesAutoresizingMaskIntoConstraints = false
            
            let topConstraint = imagesViewArr[number].topAnchor.constraint(equalTo: contentView.topAnchor)
            
            let leftConstraint = (number == 0 ? imagesViewArr[number].leftAnchor.constraint(equalTo: contentView.leftAnchor) : imagesViewArr[number].leftAnchor.constraint(equalTo: imagesViewArr[number-1].rightAnchor))
            
            let widthForConstr =  contentView.frame.width / CGFloat(imagesViewArr.count)
            let widthConstraint = imagesViewArr[number].widthAnchor.constraint(equalToConstant: widthForConstr)
            
            let heighForConstr = contentView.frame.width / CGFloat(imagesViewArr.count)
            let heightConstriant = imagesViewArr[number].heightAnchor.constraint(equalToConstant: heighForConstr )
            
            
            NSLayoutConstraint.activate([topConstraint,
                                         leftConstraint,
                                         widthConstraint,
                                         heightConstriant,
                                         imagesViewArr[number].bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            let priorityNumber = 990 - Float(number)
            topConstraint.priority = .init(priorityNumber)
        }
 
    }
    
    // вынести в extension
//    private func loadImage(byUrl stringUrl: String) -> UIImage {
//        guard let readyUrlString = URL(string: stringUrl) else { return UIImage() }
//        let data = try? Data(contentsOf: readyUrlString)
//        guard let imageData = data else { return UIImage() }
//        guard let image = UIImage(data: imageData) else { return UIImage() }
//        return image
//    }
    
    //прикрепление UIImageView
//    private func setImages(forPhotosAmount amount: Int) {
//        if amount > 1 {
//            setImages(forPhotosAmount: amount)
//            imagesArr.removeLast()
//        } else if amount == 1 {
//            let photo = UIImageView(image: imagesArr.last)
//            contentView.addSubview(photo)
//        }
//    }
    
    
}

