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
    
    //batch loading news
    let refreshControl = UIRefreshControl()
    var mostFreshNewsDate: Int?
    var nextFrom = ""
    var isLoading = false
    
    //
    var updateStatus: Bool = true
    var timer: Timer?
    var timeLeft = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            mostFreshNewsDate = myNews.first?.date ?? Date().timeIntervalSince1970.exponent
        
        setupRefreshControl()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
      
        registerTableViewCells()
        //configureNewsTableview()
        
        // настройка кнопки таймера
        setingTimerButton()
        
        //realm observer
        realmServices.startNewsRealmObserver(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNewsTableview()
        
        
        
//        sleep(2)
//        if myNews.count == 0 {
//            configureNewsTableview()
//        }
//        tableView.reloadData()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // отключаем realm observer
        token?.invalidate()
    }
    
    //MARK: -> настройки
    func configureNewsTableview(){
//        DispatchQueue.global().async {
            // регистируем cells tableview
            //self.registerTableViewCells()
            //загружаем данные с сервера VK и сохраняем в realm
            self.fetchDataFromVkServer()
            //берем данные из realm и выводим в cells
            self.myNews = self.realmServices.loadNewsDataFromRealm()
            //сортируем по дате ($0>$1)
            self.sortNewsByDate()
            //кэш фотографий
            self.imageService = ImageService(container: self.tableView)
//        }
    }
    
    func registerTableViewCells() {
        tableView.register(UINib(nibName: HeaderNewsCell.nibName, bundle: nil), forCellReuseIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: TextNewsCell.nibName, bundle: nil), forCellReuseIdentifier: TextNewsCell.reuseIdentifierOfCellNews)
        tableView.register(PhotosNewsCell.self, forCellReuseIdentifier: PhotosNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: FooterNewsCell.nibName, bundle: nil), forCellReuseIdentifier: FooterNewsCell.reuseIdentifierOfCellNews)
    }
    
    func fetchDataFromVkServer() {
        //ДЗ #2
//        DispatchQueue.global(qos: .utility).async {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        guard let timeForRequest = mostFreshNewsDate else { return }
            self.apiVkServices.getNewsPost(userId: userId, accessToken: accessToken, startTime: timeForRequest) { news in
            //сохраняем news в Realm
            self.realmServices.saveNewsData(news)
            }
//        }
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
    
    
    fileprivate func setupRefreshControl() {
       
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        self.refreshControl.beginRefreshing()
        let mostFreshNewsDate = self.myNews.first?.date ?? Date().timeIntervalSince1970.exponent
        
        apiVkServices.getNewsPost(userId: Session.shared.userId!, accessToken: Session.shared.token!, startTime: mostFreshNewsDate) { newsRealmObj in
            //guard let self = self else { return }
            self.refreshControl.endRefreshing()
            
            guard newsRealmObj.count > 0 else { return }
            self.realmServices.saveNewsData(newsRealmObj)
            //self.myNews = newsRealmObj + self.myNews
            //let indexSet = IndexSet(integersIn: 0..<newsRealmObj.count)
            //self.tableView.insertSections(indexSet, with: .automatic)
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
            //ячейка -заголовок новости
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews, for: indexPath) as? HeaderNewsCell else { return UITableViewCell() }
            headerCell.configureCell(authorName: oneNew.authorName, authorProfileImgUrl: oneNew.avatarImgUrl, date: oneNew.date)
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
                let dispatchGroup = DispatchGroup()
                
//                DispatchQueue.global(qos: .background).sync {
                    let imageOneString = oneNew.photoOneUrl
                    let imageTwoString = oneNew.photoTwoUrl
                    let imageThreeString = oneNew.photoThreeUrl
                    let imageFourString = oneNew.photoFourUrl
                    
                    let image1 = self.imageService?.photo(atIndexpath: indexPath, byUrl: imageOneString ?? "")
                    let image2 = self.imageService?.photo(atIndexpath: indexPath, byUrl: imageTwoString ?? "")
                    let image3 = self.imageService?.photo(atIndexpath: indexPath, byUrl: imageThreeString ?? "")
                    let image4 = self.imageService?.photo(atIndexpath: indexPath, byUrl: imageFourString ?? "")
                    
                    let imagesArr = [image1, image2, image3, image4]
                    
//                    DispatchQueue.main.async {
                        photoCell.configureCell(imagesArr: imagesArr)
//                    }
//                }
                return photoCell
            }
        case 3:
            //ячейка -низ новости
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

extension NewsVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        if maxSection > myNews.count - 3,
           !isLoading {
            isLoading = true
            guard let timeForRequest = mostFreshNewsDate else { return }
            apiVkServices.getNewsPost(userId: Session.shared.userId!, accessToken: Session.shared.token!, startTime: timeForRequest) { [weak self] news in
                
                print("News additional downloaded PC3")
                //self.myNews.append(news)
                self?.realmServices.saveNewsData(news)
                self?.isLoading = false
            }
        }
    }
}


extension NewsVC {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("begin draging")
//        spinner.isHidden = false
//        spinner.startAnimating()
        tableView.reloadData()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("stop draging")
//        spinner.isHidden = true
//        spinner.stopAnimating()
//        unDeleteView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        tableView.reloadData()
        return true
    }
}
