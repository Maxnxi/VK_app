//
//  PhotosCell.swift
//  Homework_1
//
//  Created by Maksim on 25.02.2021.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        let rectangle = CGRect(x: self.frame.width-42, y: self.frame.height-22, width: 40, height: 20)
        let likeVw:LikeControlView = LikeControlView(frame: rectangle)
        likeVw.isHidden = true
        addSubview(likeVw)
    }
    
    func configureCell(userPhoto: UserPhoto){
        var urlString = ""
        
        let photoSizes = userPhoto.sizes
        for element in photoSizes{
            if element.type == "x" {
                urlString = element.url
                
                print("urlString is - ",urlString)
                let data = try? Data(contentsOf: URL(string: urlString)!)
                guard let imageData = data else {
                    print("Error quit #44")
                    return }
                
                cellImgView.image = UIImage(data: imageData)
            }
        }
    }
}