//
//  FriendPhotoCollectionVC.swift
//  Homework_1
//
//  Created by Maksim on 22.02.2021.
//

import UIKit
import Foundation
import RealmSwift

class FriendPhotoCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var friendNameLbl: UILabel!
    @IBOutlet weak var friendAvatarView: AvatarView!
    
    let apiVkServices = ApiVkServices()
    let realMServices = RealMServices()
    
    //RealM Notifications
    var token: NotificationToken?
    
    var friend: UserRealMObject?
    var photos = [PhotoRealMObject]() {
        didSet{
            print("photos - set", photos.count)
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        //очистка перед загрузкой
        clearRealmDoubleCheck()
        photos = []
        collectionView.reloadData()
        // загрузка
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCollectionView()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//               
//    }
    
    func clearRealmDoubleCheck() {
        do {
            let realm = try Realm()
            //_ = try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
            let oldPhotosRequest = realm.objects(PhotoRealMObject.self)
            realm.beginWrite()
            realm.delete(oldPhotosRequest)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    // объединяющая функция
    func setupCollectionView() {
        setupViewOfFriendInfo() // информация о друге
        fetchDataPhotosFromVkServer()
        loadDataPhotosFromRealm()
        collectionView.reloadData()
    }
    
    func setupViewOfFriendInfo() {
        title = String("Фотографии \(friend?.firstName ?? "")")
        friendNameLbl.text = friend?.fullName
        
        guard let urlString = friend?.photo else { return }
        let data = try? Data(contentsOf: URL(string: urlString)!)
        guard let image = data else { return }
        friendAvatarView.avatarImage = UIImage(data: image)
    }
    
    // Загрузка данных с сервера (в RealM)
    func fetchDataPhotosFromVkServer() {
        guard let userId = friend?.id,
              let accessToken = Session.shared.token else {
            print("Error while getting friendId in - FriendPhotoCollectionViewController ")
            return
        }
            apiVkServices.getUserPhotos(userId: userId, accessToken: accessToken) { () in
                print("Downloaded photos - done")
            }
        }
    
    // загружаем из RealM
    func loadDataPhotosFromRealm() {
        do {
            guard let realm = try? Realm() else { return }
            let photosDataFromRealM = realm.objects(PhotoRealMObject.self)
            
//            self.token = photosDataFromRealM.observe({ (changes: RealmCollectionChange) in
//                print("Данные изменились!")
//                switch changes {
//                case .initial:
//                    print("initial - done")
//                    self.collectionView.reloadData()
//                case .update:
//                    print("update - done")
//                    self.collectionView.reloadData()
//                case .error(let error): print(error)
//                }
//            })
            
           photos = Array(photosDataFromRealM)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    
//    // загружаем с сервера
//    func fetchPhotosFromVkServer(userId:Int, accessToken: String) {
//        apiVkService.getUserPhotos(userId: userId, accessToken: accessToken) { (returnedPhotos) in
//            print("Downloaded photos - ", returnedPhotos.count)
//            self.photos = returnedPhotos
//        }
//    }
    
    
}


//MARK: -> CollectionDelegate and DataSource

extension FriendPhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendPhotoColCell", for: indexPath) as? PhotosCell {
            
            guard let photo = photos[indexPath.row] as? PhotoRealMObject else {
                print("Error quit #43")
                return UICollectionViewCell() }
            cell.configureCell(userPhoto: photo)
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
    
    //MARK: -> Переход к следующему ViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let viewPhoto = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoVC") as? PhotoVC else {return}
        
        viewPhoto.configureView(userPhotos: photos, photoAtIndexPath: indexPath.row)
        
        
        viewPhoto.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewPhoto, animated: true)
    }
}
