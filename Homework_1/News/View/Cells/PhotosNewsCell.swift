//
//  PhotosNewsCell.swift
//  Homework_1
//
//  Created by Maksim on 03.06.2021.
//

// REFACTORING IN PROCCESS !!!!!!!!!!

import UIKit

class PhotosNewsCell: UITableViewCell {

    private let imagesViewArr: [UIImageView] = [UIImageView(),UIImageView(),UIImageView(),UIImageView()]
    
    static let nibName: String = "PhotosNewsCell"
    static let reuseIdentifierOfCellNews: String = "photosNewsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagesViewArr.map({$0.image = nil})
    }
    
    //настройка ячейки
    func configureCell(imagesArr: [UIImage?]) {
        for i in 0..<imagesArr.count {
            guard let image = imagesArr[i] else {
                return
            }
            self.imagesViewArr[i].image = image
        }
    }

    private func settingCell() {
        let imgViewArrTmp = imagesViewArr.filter({$0.image == nil})
        print("imgViewArrTmp has photos -", imgViewArrTmp.count )
        
        for number in 0..<imgViewArrTmp.count{
            contentView.addSubview(imgViewArrTmp[number])
            imgViewArrTmp[number].translatesAutoresizingMaskIntoConstraints = false
            
            let topConstraint = imgViewArrTmp[number].topAnchor.constraint(equalTo: contentView.topAnchor)
            
            let leftConstraint = (number == 0 ? imgViewArrTmp[number].leftAnchor.constraint(equalTo: contentView.leftAnchor) : imgViewArrTmp[number].leftAnchor.constraint(equalTo: imgViewArrTmp[number-1].rightAnchor))
            
            let widthForConstr =  contentView.frame.width / CGFloat(imgViewArrTmp.count)
            let widthConstraint = imgViewArrTmp[number].widthAnchor.constraint(equalToConstant: widthForConstr)
            
            let heighForConstr = contentView.frame.width / CGFloat(imgViewArrTmp.count)
            let heightConstriant = imgViewArrTmp[number].heightAnchor.constraint(equalToConstant: heighForConstr )
            
            NSLayoutConstraint.activate([topConstraint,
                                         leftConstraint,
                                         widthConstraint,
                                         heightConstriant,
                                         imgViewArrTmp[number].bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    }
}

