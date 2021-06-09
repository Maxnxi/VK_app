//
//  NewsVC.swift
//  Homework_1
//
//  Created by Maksim on 18.03.2021.
//

import UIKit
import Foundation
import RealmSwift

class NewsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let apiVkServices = ApiVkServices()
    
    //RealM Notifications
    var token: NotificationToken?
    
    var myNews:[NewsRealmObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
                       
        tableView.register(UINib(nibName: HeaderNewsCell.nibName, bundle: nil), forCellReuseIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: TextNewsCell.nibName, bundle: nil), forCellReuseIdentifier: TextNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: PhotosNewsCell.nibName, bundle: nil), forCellReuseIdentifier: PhotosNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: FooterNewsCell.nibName, bundle: nil), forCellReuseIdentifier: FooterNewsCell.reuseIdentifierOfCellNews)
        
        
        fetchDataFromVkServer()
        loadNewsFromRealm()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchDataFromVkServer()
        loadNewsFromRealm()
        tableView.reloadData()
    }
    
    
    func fetchDataFromVkServer() {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        //ДЗ #2
        DispatchQueue.global(qos: .utility).async {
            self.apiVkServices.getNewsPost(userId: userId, accessToken: accessToken) {
                print("getNews - done")
            }
        }
        
    }
    
    func loadNewsFromRealm(){
        // ДЗ №~2
//        DispatchQueue.global(qos: .default).async {
            do {
            let realm = try Realm()
            let newsFromRealm = realm.objects(NewsRealmObject.self)
            
    //            self.token = newsFromRealm.observe({ [weak self] (changes: RealmCollectionChange) in
    //                guard let self = self, let tableView = self.tableView else { return }
    //
    //                print("Данные изменились!")
    //                switch changes {
    //                case .initial:
    //                    print("initial - done")
    //                    tableView.reloadData()
    //                case .update:
    //                    print("update - done")
    //                    tableView.reloadData()
    //                case .error(let error):
    //                    print(error)
    //                }
    //            })
//                DispatchQueue.main.async {
                    self.myNews = Array(newsFromRealm)
                    
//                }
                //to do сортировка по времени
 
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
//    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myNews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dividingStrip = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 3))
        dividingStrip.backgroundColor = .gray
        return dividingStrip
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        for section in indexPath.section
        
        let oneNew = myNews[indexPath.section]
        
        switch indexPath.row {
        case 0:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews, for: indexPath) as? HeaderNewsCell else { return UITableViewCell() }
            headerCell.configureCell(authorName: oneNew.authorName, authorProfileImgUrl: oneNew.avatarImgUrl)
            return headerCell
        case 1:
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: TextNewsCell.reuseIdentifierOfCellNews, for: indexPath) as? TextNewsCell else { return UITableViewCell() }
            textCell.configureCell(newsText: oneNew.text)
            return textCell
        case 2:
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotosNewsCell.reuseIdentifierOfCellNews, for: indexPath) as? PhotosNewsCell else { return UITableViewCell() }
            //проверка на наличие фото в новости
            if oneNew.photoOneUrl == "NO_PHOTO" || oneNew.photoOneUrl == " " {
                photoCell.minimizeView()
                return photoCell
            } else {
                photoCell.configureCell(news: oneNew)
                return photoCell
            }
            
        case 3:
            guard let footerCell = tableView.dequeueReusableCell(withIdentifier: FooterNewsCell.reuseIdentifierOfCellNews, for: indexPath) as? FooterNewsCell else { return UITableViewCell() }
            footerCell.configureCell(numOfLikes: oneNew.likes, numOfComments: oneNew.comments)
            return footerCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let oneNew = myNews[indexPath.section]
        var heightOfCell:CGFloat = 0
        switch indexPath.row {
        case 0:
            heightOfCell = 40.0
        case 1:
            if oneNew.text.count == 0 {
                heightOfCell = 0.0
            } else if oneNew.text.count > 0 && oneNew.text.count < 50 {
                heightOfCell = 40.0
            } else if oneNew.text.count > 50 && oneNew.text.count < 150 {
                heightOfCell = 60.0
            } else if oneNew.text.count > 150 && oneNew.text.count < 350 {
                heightOfCell = 100.0
            }
        case 2:
            if oneNew.photoOneUrl == "NO_PHOTO" || oneNew.photoOneUrl == "" {
                heightOfCell = 0.0
            } else {
                heightOfCell = 200.0
            }
        case 3:
            heightOfCell = 40.0
        default:
            heightOfCell = 0.0
        }
        return heightOfCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
