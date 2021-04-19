//
//  NewsVC.swift
//  Homework_1
//
//  Created by Maksim on 18.03.2021.
//

import UIKit

class NewsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var news:[News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        news = News.newsDataLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
                       
        tableView.register(UINib(nibName: NewsCellTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: NewsCellTableViewCell.reuseIdentifierOfCellNews)
    }
    

  

}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCellTableViewCell {
            cell.configureView(news: news[indexPath.row])
            return cell
        } else {
            return NewsCellTableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


