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
            print("cell - prepare")
            photoOneView.isHidden = false
            photoOneView.layer.frame.size.height = 200
            photoOneView.layer.frame.size.width = 200
            photoOneView.layer.cornerRadius = 10
            //photoOneView.center.x = self.bounds.width/2
            //photoOneView.center.y = self.bounds.height/2
            //photoOneView.clipsToBounds = true
            photoOneView.backgroundColor = .white
            
            photoOneView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        photoOneView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
                        photoOneView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
                        photoOneView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                        photoOneView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0)
                    ])
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
        
        self.photoStatusisHidden = false
        
        //TO DO добавить вариацию 4 фотографий
        guard let urlString = news.photoOneUrl as? String else { return }
        
        //ДЗ №2
//        let dispatchGroup = DispatchGroup()
        var imgView = UIImageView()
        
//        DispatchQueue.global(qos: .default).async() {
            guard let readyUrlString = URL(string: urlString) else { return }
            let data = try? Data(contentsOf: readyUrlString)
            guard let image = data else { return }
            let imgOne = UIImage(data: image)
//            DispatchQueue.main.async {
                imgView = UIImageView(image: imgOne)
//            }
//        }
        
        photoOneView.addSubview(imgView)

        imgView.contentMode = .scaleAspectFit
        //настройка констраинтов
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: photoOneView.centerXAnchor, constant: 0),
            imgView.centerYAnchor.constraint(equalTo: self.photoOneView.centerYAnchor, constant: 0),
            imgView.topAnchor.constraint(equalTo: self.photoOneView.topAnchor, constant: 0),
            imgView.bottomAnchor.constraint(equalTo: self.photoOneView.bottomAnchor, constant: 0)
        ])
    }
    
    func minimizeView() {
        self.photoStatusisHidden = true
    }
    
}
