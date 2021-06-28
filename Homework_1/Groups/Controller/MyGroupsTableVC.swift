//
//  MyGroupsTableVC.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit
import Foundation
import RealmSwift

class MyGroupsTableVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    let apiVkService = ApiVkServices()
    let realMServices = RealMServices()
    
    //RealM Notifications
    var token: NotificationToken?
    
    var myGroups:[GroupsRealMObject] = [] {
        didSet {
            print("\nУстановлено значение myGroups - !", myGroups.count)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureGroupsTableView()
        
        //realm observer
        realMServices.startGroupsRealmObserver(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        sleep(2)
//        if myGroups.count == 0 {
//            configureGroupsTableView()
//        }
//        tableView.reloadData()
    }
    
    func configureGroupsTableView() {
        fetchDataGroupsFromVkServer()
        loadDataGroupsFromRealm()
    }
    
    // Загрузка данных с сервера (в RealM)
    func fetchDataGroupsFromVkServer() {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        apiVkService.getUserGroups(userId: userId, accessToken: accessToken)
        //{
            print("fetchDataGroupsFromServer - done")
        //}
    }
    
    // загружаем из RealM
    func loadDataGroupsFromRealm() {
        do {
            guard let realm = try? Realm() else { return }
            let groupsFromRealm = realm.objects(GroupsRealMObject.self)
            
            self.token = groupsFromRealm.observe({ [weak self] (changes: RealmCollectionChange) in
                guard let self = self, let tableView = self.tableView else { return }

                print("Данные изменились!")
                switch changes {
                case .initial:
                    print("initial - done")
                    tableView.reloadData()
                case .update:
                    print("update - done")
                    self.myGroups = Array(groupsFromRealm)
                    self.sortGroups()
                    tableView.reloadData()
                case .error(let error): print(error)
                }
            })
            myGroups = Array(groupsFromRealm)
            sortGroups()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    //сортировка
    func sortGroups() {
        if !self.myGroups.isEmpty {
            self.myGroups = self.myGroups.sorted(by: {
                ($0.name.lowercased()) < ($1.name.lowercased())
            })
        }
    }
    
    //кнопка delete на tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupsCell", for: indexPath) as? MyGroupsCell {
            print("configure cell: ",indexPath.row)
            cell.configureCell(group: myGroups[indexPath.row])
            return cell
        } else {
            print("сработал UITableViewCell()")
            return UITableViewCell()
        }
    }
    
    
}
