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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var infoUpdateLabel: UILabel!
    
    //сервисы
    private let apiVkServices = ApiVkServices()
    private let realmServices = RealMServices()
    
    //кэш фото
    private var imageService: ImageService?
    
    //RealM Notifications
    public var token: NotificationToken?
    public var myNews:[NewsRealmObject] = []
    public var nextFrom = ""
    public var isTableViewScrolling = false
    
    private var lastDateString: String?
    private var isLoading = false
    private var updateStatus: Bool = true
    private var timer: Timer?
    private var timeLeft = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        startCloudAnimation(time: 2)       //cloud animation
        setupRefreshControl()       //паттерн pull to request
        setingTimerButton()     // настройка кнопки таймера (авто апдейт)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        configureNewsTableview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // отключаем realm observer
        token?.invalidate()
    }
    
    //MARK: -> настройка таблицы
    func configureNewsTableview(){
        realmServices.startNewsRealmObserver(view: self)    //realm observer
        registerTableViewCells()    //регистрируем cells tableview
        self.fetchDataFromVkServer()    //загружаем данные с сервера VK и сохраняем в realm
        //берем данные из realm и выводим в cells
        //self.myNews = self.realmServices.loadNewsDataFromRealm()
        myNews = self.sortNewsByDate(news: myNews)  //сортируем по дате ($0>$1)
        self.imageService = ImageService(container: self.tableView) //кэш фотографий
    }
    
    //MARK: -> регистрируем ячейки таблицы
    func registerTableViewCells() {
        tableView.register(UINib(nibName: HeaderNewsCell.nibName, bundle: nil), forCellReuseIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: TextNewsCell.nibName, bundle: nil), forCellReuseIdentifier: TextNewsCell.reuseIdentifierOfCellNews)
        tableView.register(PhotosNewsCell.self, forCellReuseIdentifier: PhotosNewsCell.reuseIdentifierOfCellNews)
        tableView.register(UINib(nibName: FooterNewsCell.nibName, bundle: nil), forCellReuseIdentifier: FooterNewsCell.reuseIdentifierOfCellNews)
    }
    
    //MARK: -> запрос данных с сервера VK
    private func fetchDataFromVkServer() {
        self.apiVkServices.getNewsPost(startFrom:"next_from") { news, nextFrm in
            self.nextFrom = nextFrm
            //сохраняем news в Realm
            self.realmServices.saveNewsData(news)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        //self.lastDateString = String(Int(myNews.first?.date ?? Int(Date().timeIntervalSince1970))) //- (60 * 60 * 2))
        guard let lastDate = self.myNews.first?.date else { return }
        self.lastDateString = String(describing: Int(lastDate))
        print("lastDateString is - ", lastDateString )
            //.fromDoubleToStringDateFormatToCell(date: self.myNews.first?.date ?? Double(Date().timeIntervalSince1970))
    }
    
    func sortNewsByDate(news:[NewsRealmObject]) -> [NewsRealmObject]{
        return news.sorted(by: {$0.date > $1.date})
    }
}

//MARK: -> настройка таблицы
extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myNews.count
    }
    //фиксировано 4 ячейки под каждую новость
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    //разделитель между блоками новостей
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dividingStrip = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 3))
        dividingStrip.backgroundColor = .gray
        return dividingStrip
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }

    //конфигурация ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneNew = myNews[indexPath.section]
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
            photoCell.configureCell(image: oneNew.photoOneUrl ?? "")
            return photoCell
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
    
    //высота ячеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let oneNew = myNews[indexPath.section]
        var heightOfCell:CGFloat = 0
        switch indexPath.row {
        case 0:
            heightOfCell = 40.0
        case 1:
            if oneNew.text.count == 0 {
                heightOfCell = 0.0
            } else {
                heightOfCell = UITableView.automaticDimension
            }
//            else if oneNew.text.count > 0 && oneNew.text.count <= 150 {
//                heightOfCell = UITableView.automaticDimension
//            } else if oneNew.text.count > 150  {
//                heightOfCell = 200.0
//            }
        case 2:
            print("case 2")
            if oneNew.photoOneUrl == "NO_PHOTO", oneNew.photoOneUrl == ""  {
                heightOfCell = 0.0
            } else {
                let width = view.frame.width
                let cellHeight = width * CGFloat(oneNew.aspectRatio ?? 1)
                heightOfCell = cellHeight
            }
        case 3:
            heightOfCell = 40.0
        default:
            heightOfCell = 0.0
        }
        return heightOfCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.tableView.beginUpdates()
            
            self.tableView.endUpdates()
        default:
            print("nothing")
        }
    }
}

//MARK: -> паттерн Infinite Scrolling
extension NewsVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        
        if maxSection > myNews.count - 3, !isLoading {
            self.isTableViewScrolling = true
            print("Prefetch begins, maxsections is - \(maxSection), nextFrom is - ", nextFrom.description)
            isLoading = true
            
            apiVkServices.getNewsPost(startFrom: nextFrom) { [weak self] news, nextFrm in
                self?.nextFrom = nextFrm
                guard let self = self else { return }
                self.realmServices.saveNewsData(news)
                self.isLoading = false
            }
        }
    }
}

//MARK: -> паттерн pull to request (обновление страницы когда в самом верху тащим сверху-вниз)
extension NewsVC {
    fileprivate func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        tableView.refreshControl?.tintColor = .orange
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .allEvents)
    }
    
    @objc func refreshNews() {
        self.isTableViewScrolling = false
        guard let date = lastDateString else {
            tableView.refreshControl?.endRefreshing()
            print("refresh control ended")
            return
        }
        print("start_time is ", date)
        apiVkServices.getNewsPost(startTime: date, startFrom: "next_from") { news, startFrm in
            //guard let self = self else { return }
            self.realmServices.saveNewsData(news)
            
            guard let dateToConvert = self.myNews.first?.date else { return }
            
            
            self.lastDateString = String(describing: Int(dateToConvert)) //self.convertDatetoVK(timeIntervalSince1970: dateToConvert ?? 0)
            
            // self.myNews.first?.date.fromIntToDateFormatToCell(date: self.myNews.first?.date ?? Int(Date().timeIntervalSince1970))
        }
        self.tableView.refreshControl?.endRefreshing()
    }
    

    
//    class DateFormatterVK {
//        let dateFormatter = DateFormatter()
//
//        func convertDate(timeIntervalSince1970: Double) -> String{
//            dateFormatter.dateFormat = "MM-dd-yyyy HH.mm"
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//            let date = Date(timeIntervalSince1970: timeIntervalSince1970)
//            return dateFormatter.string(from: date)
//        }
//    }
    func convertDatetoVK(timeIntervalSince1970: Double) -> String{
        if timeIntervalSince1970 == 0 {
            return ""
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH.mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let date = Date(timeIntervalSince1970: timeIntervalSince1970)
            return dateFormatter.string(from: date)
        }
    }
}
    
//MARK: -> Дополнительный таймер вверху таблицы (вызов каждые 60 секунд - fetchDataFromVkServer())
extension NewsVC {
    func setingTimerButton() {
        updateButton.isUserInteractionEnabled = true
        updateButton.layer.cornerRadius = updateButton.frame.width/2
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }
    
    @objc func timerFunc() {
        if updateStatus == true {
            timeLeft -= 1
            timerLabel.text = "\(timeLeft)"
            if timeLeft == 0 {
                startCloudAnimation(time: 2)       //cloud animation
                fetchDataFromVkServer()
                timeLeft = 60
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                self.isTableViewScrolling = false
            }
        } else {
            // print("")
        }
    }
    
    @IBAction func updatePauseBtnWasPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.18) {
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

//MARK: -> cloud animation
extension NewsVC {
    func startCloudAnimation(time: Int) {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.addSubview(coverView)
        coverView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        coverView.alpha = 0.6
        UIView.startLoadingCloudAnimation(view: coverView, time: time)
    }
}
