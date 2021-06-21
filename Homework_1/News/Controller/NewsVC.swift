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
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var infoUpdateLabel: UILabel!
    
    private let apiVkServices = ApiVkServices()
    private let realmServices = RealMServices()
    
    //кэш фото
    private var imageService: ImageService?
    
    //RealM Notifications
    var token: NotificationToken?
    
    var myNews:[NewsRealmObject] = []
    
    var updateStatus: Bool = true
    
    var timer: Timer?
    var timeLeft = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageService = ImageService(container: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // регистируем cells tableview
        registerTableViewCells()
        
        configureNewsTableview()
        
        // настройка кнопки таймера
        setingTimerButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(2)
        if myNews.count == 0 {
            fetchDataFromVkServer()
        }
        //realm observer
        realmServices.startNewsRealmObserver(view: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // отключаем realm observer
        token?.invalidate()
    }
    
    //MARK: -> настройки
    func registerTableViewCells(){
        tableView.register(UINib(nibName: HeaderNewsCell.nibName, bundle: nil), forCellReuseIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: TextNewsCell.nibName, bundle: nil), forCellReuseIdentifier: TextNewsCell.reuseIdentifierOfCellNews)
        tableView.register(PhotosNewsCell.self, forCellReuseIdentifier: PhotosNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: FooterNewsCell.nibName, bundle: nil), forCellReuseIdentifier: FooterNewsCell.reuseIdentifierOfCellNews)
    }
    
    func configureNewsTableview(){
        //загружаем данные с сервера VK и сохраняем в realm
        fetchDataFromVkServer()
        //берем данные из realm и выводим в cells
        myNews = realmServices.loadNewsDataFromRealm()
        //сортируем по дате ($0>$1)
        sortNewsByDate()
    }
    
    func fetchDataFromVkServer() {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        //ДЗ #2
        DispatchQueue.global(qos: .utility).async {
            self.apiVkServices.getNewsPost(userId: userId, accessToken: accessToken) { news in
            //сохраняем news в Realm
            self.realmServices.saveNewsData(news)
            }
        }
    }
    
    func sortNewsByDate(){
        myNews = myNews.sorted(by: {$0.date > $1.date})
    }
    
    func setingTimerButton(){
        updateButton.isUserInteractionEnabled = true
        updateButton.layer.cornerRadius = updateButton.frame.width/2
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }
    
    @objc func timerFunc() {
        if updateStatus == true {
            timeLeft -= 1
            timerLabel.text = "\(timeLeft)"
            if timeLeft == 0 {
                fetchDataFromVkServer()
                timeLeft = 60
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        } else {
           // print("")
        }
    }
    
    @IBAction func updatePauseBtnWasPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.18) { // 0.1 - слишком быстро
            self.updateButton.imageView?.layer.contentsScale = 1.8
            self.updateButton.backgroundColor = .darkGray
        } completion: { _ in
            self.updateButton.imageView?.layer.contentsScale = 1
            self.updateButton.backgroundColor = .clear
        }
        
        if updateStatus == true {
            updateStatus = false
            print("news update status - off")
            updateButton.setImage(UIImage(systemName: "play"), for: .normal)
        } else if updateStatus == false {
            updateStatus = true
            print("news update status - on")
            updateButton.setImage(UIImage(systemName: "pause"), for: .normal)
        }
    }
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
        let oneNew = myNews[indexPath.section]
        //print("oneNew is - ", oneNew)
        switch indexPath.row {
        case 0:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews, for: indexPath) as? HeaderNewsCell else { return UITableViewCell() }
            headerCell.configureCell(authorName: oneNew.authorName, authorProfileImgUrl: oneNew.avatarImgUrl)
            return headerCell
        case 1:
            //ячейка -текст новости
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: TextNewsCell.reuseIdentifierOfCellNews, for: indexPath) as? TextNewsCell else { return UITableViewCell() }
            textCell.configureCell(newsText: oneNew.text)
            return textCell
        case 2:
            //ячейка -фото новости
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotosNewsCell.reuseIdentifierOfCellNews) as? PhotosNewsCell else {
                print("Ошибка №320")
                return UITableViewCell()
            }
            //проверка на наличие фото в новости
            
            if oneNew.photoOneUrl == "NO_PHOTO" {
                
                return photoCell
            } else {
                
                //guard
                let imageOneString = oneNew.photoOneUrl
                let imageTwoString = oneNew.photoTwoUrl
                      let imageThreeString = oneNew.photoThreeUrl
                let imageFourString = oneNew.photoFourUrl
//                else {
//                    print("Ошибка №321")
//                    return UITableViewCell()
//                }
                
                let image1 = imageService?.photo(atIndexpath: indexPath, byUrl: imageOneString ?? "")
                 let image2 = imageService?.photo(atIndexpath: indexPath, byUrl: imageTwoString ?? "")
                let image3 = imageService?.photo(atIndexpath: indexPath, byUrl: imageThreeString ?? "")
                 let image4 = imageService?.photo(atIndexpath: indexPath, byUrl: imageFourString ?? "")
                
                let imagesArr = [image1, image2, image3, image4]
                print("cell #\(indexPath.row) has photos:\(imagesArr.count)")
                photoCell.configureCell(imagesArr: imagesArr)
                return photoCell
            }
        case 3:
            guard let footerCell = tableView.dequeueReusableCell(withIdentifier: FooterNewsCell.reuseIdentifierOfCellNews, for: indexPath) as? FooterNewsCell else {
                print("Ошибка №322")
                return UITableViewCell()
            }
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
            print("case 2")
            if oneNew.photoOneUrl == "NO_PHOTO" {
                heightOfCell = 0.0
            } else {
                heightOfCell = 100.0
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
