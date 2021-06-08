//
//  PhotosNewsCell.swift
//  Homework_1
//
//  Created by Maksim on 03.06.2021.
//

import UIKit

class PhotosNewsCell: UITableViewCell {

    @IBOutlet weak var photoOneView: UIView!
    
    static var nibName: String = "PhotosNewsCell"
    static var reuseIdentifierOfCellNews: String = "photosNewsCell"
    
    var photoStatusisHidden: Bool? = false
    var viewHeight:CGFloat?
    //{
//        didSet{
//            setNeedsDisplay()
//        }
    //}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        print("Загрузка PhotoCell, photoStatusisHidden -", photoStatusisHidden)
        if photoStatusisHidden == true {
            photoOneView.isHidden = true
            contentView.bounds.size.height = 0
        } else {
            photoOneView.isHidden = false
            contentView.bounds.size.height = 200
        }
        
        
        
                
//        photoOneView.frame.size.width = 120
//        photoOneView.frame.size.height = 120
        
//        photoOneView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            photoOneView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
//            photoOneView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
//        ])

    }
    
    func configureCell(news: NewsRealmObject) {
        //self.viewHeight = 200
        self.photoStatusisHidden = false
        //TO DO добавить вариацию 4 фотографий
        
        guard let urlString = news.photoOneUrl as? String else { return }
        guard let readyUrlString = URL(string: urlString) else { return }
        let data = try? Data(contentsOf: readyUrlString)
        guard let image = data else { return }
        let imgOne = UIImage(data: image)
        let imgView = UIImageView(image: imgOne)
        self.addSubview(imgView)
        
        imgView.contentMode = .scaleAspectFit
        
        //настройка констраинтов
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: photoOneView.centerXAnchor, constant: 0),
            imgView.centerYAnchor.constraint(equalTo: photoOneView.centerYAnchor, constant: 0),
            imgView.topAnchor.constraint(equalTo: photoOneView.topAnchor, constant: 0),
            imgView.bottomAnchor.constraint(equalTo: photoOneView.bottomAnchor, constant: 0)
        ])
        
    }
    
    func minimizeView() {
        self.viewHeight = 0
        self.photoStatusisHidden = true
    }
    
}
