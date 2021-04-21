//
//  MyGroupsTableVC.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit
import Foundation

class MyGroupsTableVC: UIViewController {

    var myGroups:[Group] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        repeat {
            sleep(4)
            configureGroupsTableView()
        } while (myGroups.isEmpty)
    }
    
    func configureGroupsTableView() {
        loadGroups()
        tableView.reloadData()
    }
    
    func loadGroups() {
        myGroups = ALL_MY_GROUPS
        print("groups pushed to GroupsTableVC", myGroups.count)
        
        if !myGroups.isEmpty {
            myGroups = myGroups.sorted(by: {
                ($0.name?.lowercased())! < ($1.name?.lowercased())!
            })
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
        //let group = globGroups[indexPath.row]
        
//        for index in 0..<myGroups.count {
//            if (myGroups[index].name == group.name) {
//                return
//            }
//        }
//        
//        myGroups.append(group)
        tableView.reloadData()
    }
}


extension MyGroupsTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupsCell {
            cell.configureCell(group: myGroups[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
