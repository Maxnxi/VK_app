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
        //newsImageView.image = nil
    }

    private func settingCell() {
        //скачиваем фото в массив
        DispatchQueue.global(qos: .utility).async {
            for i in 0..<self.imagesUrlStringArr.count {
                self.imagesArr.append(self.loadImage(byUrl: self.imagesUrlStringArr[i]))
            }
        }
        
    }
    
    private func loadImage(byUrl stringUrl: String) -> UIImage {
        guard let readyUrlString = URL(string: stringUrl) else { return UIImage() }
        let data = try? Data(contentsOf: readyUrlString)
        guard let imageData = data else { return UIImage() }
        guard let image = UIImage(data: imageData) else { return UIImage() }
        return image
    }
    
    //прикрепление UIImageView
    private func setImages(forPhotosAmount amount: Int) {
        if amount > 1 {
            setImages(forPhotosAmount: amount)
            imagesArr.removeLast()
        } else if amount == 1 {
            let photo = UIImageView(image: imagesArr.last)
            contentView.addSubview(photo)
        }
    }
    
    //настройка ячейки
    func configureCell(imagesArr: [UIImage]?) {
        self.imagesArr = imagesArr
    }
}


/*
 //настройка констраинтов
 imgView.translatesAutoresizingMaskIntoConstraints = false
 NSLayoutConstraint.activate([
     imgView.centerXAnchor.constraint(equalTo: photoOneView.centerXAnchor, constant: 0),
     imgView.centerYAnchor.constraint(equalTo: self.photoOneView.centerYAnchor, constant: 0),
     imgView.topAnchor.constraint(equalTo: self.photoOneView.topAnchor, constant: 0),
     imgView.bottomAnchor.constraint(equalTo: self.photoOneView.bottomAnchor, constant: 0)
 ])
 */
