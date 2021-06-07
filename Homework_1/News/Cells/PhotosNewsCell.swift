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
    
    var viewHeight:CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        photoOneView.isHidden = false
        
        contentView.bounds.size.height = 60
                
        photoOneView.frame.size.width = 40
        photoOneView.frame.size.height = 40
        
        photoOneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoOneView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            photoOneView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ])

    }
    
    func configureCell(newsPhoto: String) {
        self.viewHeight = 60
        
        guard let urlString = newsPhoto as? String else { return }
        let data = try? Data(contentsOf: URL(string: urlString)!)
        guard let image = data else { return }
        let imgOne = UIImage(data: image)
        let imgView = UIImageView(image: imgOne)
        self.addSubview(imgView)
        
        //настройка констраинтов
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: photoOneView.centerXAnchor, constant: 0),
            imgView.centerYAnchor.constraint(equalTo: photoOneView.centerYAnchor, constant: 0)
        ])
        
    }
    
    func minimizeView() {
        self.viewHeight = 0
    }
    
}
