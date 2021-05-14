//
//  MyGroupsTableVC.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit
import Foundation

class MyGroupsTableVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var myGroups:[GroupsRealMObject] = []
    let apiVkService = ApiVkServices()
    let realMServices = RealMServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureGroupsTableView()
    }
    
    func configureGroupsTableView() {
        loadGroups()
    }
    
    func loadGroups() {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        
        apiVkService.getUserGroups(userId: userId, accessToken: accessToken) {
            
            // загружаем из RealM
            self.realMServices.loadGroupssData { loadedGroupsFromRealM in
                
                self.myGroups = loadedGroupsFromRealM
                print("groups pushed to GroupsTableVC", self.myGroups.count)
                if !self.myGroups.isEmpty {
                    self.myGroups = self.myGroups.sorted(by: {
                        ($0.name.lowercased()) < ($1.name.lowercased())
                    })
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? MyGroupsCell {
            cell.configureCell(group: myGroups[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
