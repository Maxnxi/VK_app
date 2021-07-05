////
////  PhotoAlbumsASCollection.swift
////  Homework_1
////
////  Created by Maksim on 03.07.2021.
////
//
//import UIKit
//import Foundation
//import AsyncDisplayKit
//
//class PhotoAlbumsASCollection: ASDKViewController<ASDisplayNode>, ASCollectionDelegate, ASCollectionDataSource {
//    
//    var collectionNode: ASCollectionNode
////    {
////        return node as! ASCollectionNode
////    }
//    
//    var friend: String?
//    //сетевой запрос
//    let apiVkServices = ApiVkServices()
//    //массив хранящий данные
//    var totalAlbums: [PhotoAlbumModel] = []
//    
//    override init() {
//        let flowLayout = UICollectionViewFlowLayout()
//        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
//        super.init(node: collectionNode)
//        self.collectionNode.delegate = self
//        self.collectionNode.dataSource = self
//        self.collectionNode.allowsSelection = false
//        
//        flowLayout.minimumInteritemSpacing = 1
//          flowLayout.minimumLineSpacing = 1
//        flowLayout.estimatedItemSize = CGSize(width: collectionNode.frame.size.width / 2, height: collectionNode.frame.size.width/2)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//      super.viewDidLoad()
//      collectionNode.view.allowsSelection = true
//      collectionNode.view.backgroundColor = .white
//        fetchDataPhotosFromVkServer()
//    }
//
//    //настройка коллекции
//    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
//        return totalPhotos.count
//    }
//    
////    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
////
////        guard totalPhotos.count > indexPath.row else { return ASCellNode() }
////
////        let photo = totalPhotos[indexPath.row]
////            let cellNode = { () -> ASCellNode in
////                let node = PhotoNode(resource: photo)
////                return node
////            }
////        return cellNode() // вопрос ()
////
////    }
//    
//    
//    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
//        guard totalPhotos.count > indexPath.row else { return { ASCellNode() } }
//        let photo = totalPhotos[indexPath.row]
//            let cellNodeBlock = { () -> ASCellNode in
//                let node = PhotoNode(resource: photo)
//                return node
//            }
//        return cellNodeBlock
//    }
//    
//    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
//        let width = CGFloat(UIScreen.main.bounds.size.width/2.5) //)(collectionNode.frame.width / 2) - 10
//        let min = CGSize(width: width, height: width)
//        let max = CGSize(width: width, height: CGFloat(totalPhotos[indexPath.row].aspectRatio*width))
//        return ASSizeRange(min: min, max: max)
//    }
//     
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.width / 2) - 10
//        return CGSize(width: width, height: width)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//    
////    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
////        return true
////    }
//    
//    // переход на следующий экран при выборе фото
//    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
//        guard let viewPhoto = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoVC") as? PhotoVC else {return}
//        viewPhoto.configureViewNew(userPhotos: totalPhotos, photoAtIndexPath: indexPath.row)
//        viewPhoto.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(viewPhoto, animated: true)
//    }
//    
//    // Загрузка данных с сервера
//    func fetchDataPhotosFromVkServer() {
//        guard let userId = friend?.id,
//              let accessToken = Session.shared.token else {
//            print("Error while getting friendId in - FriendPhotoCollectionViewController ")
//            return
//        }
//            apiVkServices.getUserPhotos(userId: userId, accessToken: accessToken) { photos in
//                print("Doznloaded photos - done")
//                self.totalPhotos = photos
//                self.collectionNode.reloadData()
//            }
//        }
//    
//}
