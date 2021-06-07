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
    
    let apiVkServices = ApiVkServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
                       
        tableView.register(UINib(nibName: HeaderNewsCell.nibName, bundle: nil), forCellReuseIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews)
        
        
        fetchDataFromVkServer()
    }
    
    
    func fetchDataFromVkServer() {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        apiVkServices.getNews(userId: userId, accessToken: accessToken) {
            print("getNews - done")
        }
    }
    

  

}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        let headerView = UIView(frame: rect)
        headerView.backgroundColor = .yellow
        
        let rectForAvatar = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imageProfileAuthor = AvatarView(frame: rectForAvatar)
        imageProfileAuthor.backgroundColor = .green
        imageProfileAuthor.imageView.image = UIImage(named: "profile")

        let nameAuthorLbl = UILabel()
        nameAuthorLbl.text = "$nameAuthorLbl"
        
        headerView.addSubview(imageProfileAuthor)
        headerView.addSubview(nameAuthorLbl)
        
        imageProfileAuthor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageProfileAuthor.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0),
            imageProfileAuthor.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            imageProfileAuthor.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 12)
        ])
        
        nameAuthorLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameAuthorLbl.leftAnchor.constraint(equalTo: imageProfileAuthor.rightAnchor, constant: 12),
            nameAuthorLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0)
        ])
        
        
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let header = tableView.dequeueReusableCell(withIdentifier: HeaderNewsCell.reuseIdentifierOfCellNews, for: indexPath)
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


