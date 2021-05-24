//
//  NewsVC.swift
//  Homework_1
//
//  Created by Maksim on 18.03.2021.
//

import UIKit
import Foundation

class NewsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var news:[News] = []
    let apiVkService = ApiVkServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //news = News.newsDataLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchNewsInfoFromVkServer()
        
        //        tableView.register(UINib(nibName: NewsCellTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: NewsCellTableViewCell.reuseIdentifierOfCellNews)
    }
    
    func fetchNewsInfoFromVkServer() {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        
        apiVkService.getNewsfeed(userId: userId, accessToken: accessToken) {
            print("newsFeed get - succes")
        }
    }
  

}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCellTableViewCell {
//            cell.configureView(news: news[indexPath.row])
//            return cell
//        } else {
//            return NewsCellTableViewCell()
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
}


