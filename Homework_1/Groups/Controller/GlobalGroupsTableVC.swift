//
//  GlobalGroupsTableVC.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import UIKit

class GlobalGroupsTableVC: UIViewController {
    
    //let globalGroups:[Group] = Group.loadData()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension GlobalGroupsTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3//globalGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "globalGroupCell", for: indexPath) as? GlobalGroupCell {
            //cell.configureCell(group: globalGroups[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
