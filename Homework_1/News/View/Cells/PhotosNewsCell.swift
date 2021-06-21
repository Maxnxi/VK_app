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
    //private var imagesArr: [UIImage] = []
    
    static let nibName: String = "PhotosNewsCell"
    static let reuseIdentifierOfCellNews: String = "photosNewsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingCell()
    }
    
    required init?(coder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
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
            //self.imagesArr.append(image)
            self.imagesViewArr[i].image = image
        }
        //self.imagesArr = imagesArr ?? []
        //print("")
    }

    private func settingCell() {
        //to do - to think how optimize
        
        //print("/n NewsPhotoCell - imagesArr.count - ", imagesArr.count)
//        for i in 0..<imagesViewArr.count {
//            if imagesViewArr[i] == nil {
//                imagesViewArr.remove(at: i)
//            }
//        }
        
        let imgViewArrTmp = imagesViewArr.filter({$0.image == nil})
        print("imgViewArrTmp has photos -", imgViewArrTmp.count )
        
        for number in 0..<imgViewArrTmp.count{
            contentView.addSubview(imgViewArrTmp[number])
            imgViewArrTmp[number].translatesAutoresizingMaskIntoConstraints = false
           //imagesViewArr[number].contentMode = .scaleAspectFit
            
            let topConstraint = imgViewArrTmp[number].topAnchor.constraint(equalTo: contentView.topAnchor)
            
            let leftConstraint = (number == 0 ? imgViewArrTmp[number].leftAnchor.constraint(equalTo: contentView.leftAnchor) : imgViewArrTmp[number].leftAnchor.constraint(equalTo: imgViewArrTmp[number-1].rightAnchor))
            
            let widthForConstr =  contentView.frame.width / CGFloat(imgViewArrTmp.count)
            let widthConstraint = imgViewArrTmp[number].widthAnchor.constraint(equalToConstant: widthForConstr)
            
            let heighForConstr = contentView.frame.width / CGFloat(imgViewArrTmp.count)
            let heightConstriant = imgViewArrTmp[number].heightAnchor.constraint(equalToConstant: heighForConstr )
            
            //let centerConstraint = contentView.centerXAnchor.constraint(equalTo: centerXAnchor)
            
            
            NSLayoutConstraint.activate([topConstraint,
                                         leftConstraint,
                                         widthConstraint,
                                         heightConstriant,
                                         imgViewArrTmp[number].bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            //let priorityNumber = 990 - Float(number)
            //topConstraint.priority = .init(priorityNumber)
        }
 
    }
    
    
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

