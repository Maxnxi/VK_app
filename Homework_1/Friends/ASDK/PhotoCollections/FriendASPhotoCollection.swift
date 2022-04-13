//
//  FriendASPhotoCollectionVC.swift
//  Homework_1
//
//  Created by Maksim on 30.06.2021.
//

import UIKit
import Foundation
import AsyncDisplayKit

class FriendASPhotoCollectionVC: ASDKViewController<ASDisplayNode>, ASCollectionDelegate, ASCollectionDataSource {
    
    static let identifier = "friendASPhotoCollectionVC"
    
    var collectionNode: ASCollectionNode
//    {
//        return node as! ASCollectionNode
//    }
    
    var friend: UserRealMObject?
    //сетевой запрос
    let apiVkServices = ApiVkServices()

    //массив хранящий данные
    var totalPhotos: [PhotoModel] = []

    //не подключено
    //дозагрузка данных - infinite scrolling
    var offSet = 0
    
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.allowsSelection = false
        
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.estimatedItemSize = CGSize(width: collectionNode.frame.size.width/3 - 3, height: collectionNode.frame.size.width/3 - 3)
        //flowLayout.estimatedItemSize = CGSize(width: collectionNode.frame.size.width / 3 - 3, height: collectionNode.frame.size.width/3 - 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      collectionNode.view.allowsSelection = true
      collectionNode.view.backgroundColor = .white
        
        let dataFromServer = self.fetchDataPhotosFromVkServer(offSetIs: self.offSet)

        print("dataFromServer.photos", dataFromServer.photos.count)
        self.totalPhotos = dataFromServer.photos
        print("totalPhotos is - ", self.totalPhotos.count)
        self.offSet = dataFromServer.offSet
        self.collectionNode.reloadData()
    }

    //настройка коллекции
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return totalPhotos.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard totalPhotos.count > indexPath.row else { return { ASCellNode() } }
        let photo = totalPhotos[indexPath.row]
            let cellNodeBlock = { () -> ASCellNode in
                let node = PhotoNode(resource: photo)
                return node
            }
        return cellNodeBlock
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let widthRounded = (collectionNode.frame.size.width/3).rounded()
        let width = CGFloat(widthRounded - 3)
        //(UIScreen.main.bounds.size.width/3 - 3) //)(collectionNode.frame.width / 2) - 10
        //let width = CGFloat(50)
        
        let min = CGSize(width: width, height: width)
        let heightWithAspectRatio = width * (totalPhotos[indexPath.row].aspectRatio).rounded()
        let max = CGSize(width: width, height: heightWithAspectRatio)
        return ASSizeRange(min: min, max: max)
    }
    
    // переход на следующий экран при выборе фото
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        guard let viewPhoto = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoVC") as? PhotoVC else {return}
        viewPhoto.configureViewNew(userPhotos: totalPhotos, photoAtIndexPath: indexPath.row)
        viewPhoto.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewPhoto, animated: true)
    }
    
    // Загрузка данных с сервера
    private func fetchDataPhotosFromVkServer(offSetIs: Int) -> (photos:[PhotoModel], offSet: Int) {
        guard let userId = friend?.id,
              let accessToken = Session.shared.token else {
            print("Error while getting friendId in - FriendPhotoCollectionViewController ")
            return ([], 0)
        }
        var photosTmp = [PhotoModel]()
        var newOffSet = 0
            apiVkServices.getUserPhotos(userId: userId, accessToken: accessToken, offSet: offSet) { photos, newOffset in
                print("Downloaded photos - done", photos.count)
                photosTmp = Array(photos)
                self.totalPhotos = photos
                newOffSet = newOffset
                self.offSet = newOffset
                self.collectionNode.reloadData()
            }
    return (photosTmp, newOffSet)
    }
}

//MARK: -> не подключено

//    func setNoPhotoLbl() {
//        self.view.addSubview(noPhotoLbl)
//        self.view.bringSubviewToFront(noPhotoLbl)
//        noPhotoLbl.text = "No photos found"
//        noPhotoLbl.textColor = .black
//        noPhotoLbl.sizeThatFits(CGSize(width: 250, height: 50))
//        noPhotoLbl.isHidden = true
//        noPhotoLbl.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            noPhotoLbl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            noPhotoLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
//        ])
//
//    }

//    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
//        return true
//    }
    
//    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
//        let dataFromServer = fetchDataPhotosFromVkServer(offSetIs: offSet)
//        guard let photos = dataFromServer.photos else { return }
//        self.offSet = dataFromServer.offSet
//
//        //let indexSet = IndexSet(integersIn: self.totalPhotos.count..<self.totalPhotos.count+photos.count)
//
//        //let indexPth = IndexPath(item: self.totalPhotos.count, section: 1)
//
//        var indexPathArr = [IndexPath]()
//        for i in self.totalPhotos.count..<self.totalPhotos.count+photos.count {
//            let indexPth = IndexPath(item: i, section: 1)
//            indexPathArr.append(indexPth)
//        }
//        self.totalPhotos.append(contentsOf: photos)
//        self.collectionNode.insertItems(at: indexPathArr)
//    }
