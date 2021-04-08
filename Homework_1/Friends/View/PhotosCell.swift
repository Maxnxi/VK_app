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
        let likeVw:LikeControl = LikeControl(frame: rectangle)
        addSubview(likeVw)
    }
    
    func configureCell(image: UIImage){
        self.cellImgView.image = image
    }

}
