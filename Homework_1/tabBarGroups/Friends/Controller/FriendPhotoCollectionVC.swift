//
//  FriendPhotoCollectionVC.swift
//  Homework_1
//
//  Created by Maksim on 22.02.2021.
//

import UIKit

class FriendPhotoCollectionVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var friendNameLbl: UILabel!
    @IBOutlet weak var friendAvatarView: AvatarView!
    
    var friend: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(friend?.firstName)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let firstName = friend?.firstName ?? ""
        title = String("Фотографии \(firstName)")
        
        self.friendNameLbl.text = friend?.fullName
        self.friendAvatarView.avatarImage = friend?.avatarImage
        //self.friendAvatarView.avatarImage = UIImage(named: String(friend?.avatarImg ?? "profileDefault"))
    }
}

extension FriendPhotoCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        IMAGES_ARRAY.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendPhotoColCell", for: indexPath) as? PhotosCell {
            guard let image = IMAGES_ARRAY[indexPath.row] else { return UICollectionViewCell() }
            cell.configureCell(image: image)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       guard let viewPhoto = storyboard.instantiateViewController(withIdentifier: "photoVC") as? PhotoVC else {return}
        viewPhoto.configureView(imageAtIndexPath: indexPath.row)
        viewPhoto.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewPhoto, animated: true)
    }
    
}
