//
//  MyGroupsTableVC.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit
import Foundation
import RealmSwift
import Firebase

class MyGroupsTableVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var communitesFirebase = [FirebaseCommunity]()
    private let ref = Database.database().reference(withPath: "Users")
    
    private let groupAdapter = GroupAdapter()
    private var groupsArray: [GroupVK] = []
//    private let apiVkService = ApiVkServices()
//    private let realMServices = RealMServices()
    
//    public var myGroups = [GroupsRealMObject]()
    //insert adapter
    
    //RealM Notifications
    //public var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        startCloudAnimation(time: 3) //cloud animation
        
        groupAdapter.getGroups { [weak self] groups in
            guard let self = self else { return }
            self.groupsArray = groups
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //realMServices.startGroupsRealmObserver(view: self)  //realm observer
        configureGroupsTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // закрываем token Realm
        super.viewDidDisappear(animated)
       // token?.invalidate()
    }
    
    func configureGroupsTableView() {
        //fetchDataGroupsFromVkServer()
        refObserve()
    }
    
    // Загрузка данных с сервера (в RealM)
//    func fetchDataGroupsFromVkServer() {
//        guard let userId = Session.shared.userId,
//              let accessToken = Session.shared.token else {
//            print("error getting userId")
//            return
//        }
//        apiVkService.getUserGroups(userId: userId, accessToken: accessToken)
//            print("fetchDataGroupsFromServer - done")
//    }
    
    //сортировка
    func sortGroups() {
        if !self.groupsArray.isEmpty {
            self.groupsArray = self.groupsArray.sorted(by: {
                ($0.groupName.lowercased()) < ($1.groupName.lowercased())
            })
        }
    }
    
    //кнопка delete на tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupsArray.remove(at: indexPath.row)
        }
    }
    
    func refObserve() {
        ref.observe(.value, with: { snapshot in
            var communities: [FirebaseCommunity] = []
           
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let city = FirebaseCommunity(snapshot: snapshot) {
                    communities.append(city)
                }
            }
            print("Обновлен список добавленных групп")
            communities.forEach{ print($0.name) }
            print(communities.count)
        })
    }

    @IBAction func unwindFromGlobGroups(_ segue:UIStoryboardSegue){
        guard let controller = segue.source as? GlobalGroupsTableVC,
              let indexPath = controller.tableView.indexPathForSelectedRow
        else { return }
        tableView.reloadData()
    }
}

extension MyGroupsTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupsCell", for: indexPath) as? MyGroupsCell {
            print("configure cell: ",indexPath.row)
            cell.configureCell(with: groupsArray[indexPath.row])
            return cell
        } else {
            print("сработал UITableViewCell()")
            return UITableViewCell()
        }
    }
}

//MARK: -> cloud animation
extension MyGroupsTableVC {
    func startCloudAnimation(time: Int) {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.addSubview(coverView)
        coverView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        coverView.alpha = 0.6
        UIView.startLoadingCloudAnimation(view: coverView, time: time)
    }
}
