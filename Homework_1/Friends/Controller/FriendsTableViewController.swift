//
//  FriendsTableVC.swift
//  Homework_1
//
//  Created by Maksim on 22.02.2021.
//
import UIKit
import Foundation
import RealmSwift

class FriendsTableViewController: UIViewController  {
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let apiVkServices = ApiVkServices()
    let realMServices = RealMServices()

    //RealM Notifications
    var token: NotificationToken?
    
    var myFriends:[UserRealMObject] = [] {
        didSet {
            tableView.reloadData()
            print("myFriend set!")
        }
    }
    var filterListOfFriends: [UserRealMObject] = []
    var sections: [String] = []
    var cachedSectionsItems: [String:[UserRealMObject]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureFriendsTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureFriendsTableView()
    }
    
    
    func configureFriendsTableView() {
        fetchDataFriendsFromVkServer()
        loadDataFriendsFromRealm()
        setupDataSource()
    }
    
    // Загрузка данных с сервера (в RealM)
    func fetchDataFriendsFromVkServer() {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        apiVkServices.getFriends(userId: userId, accessToken: accessToken) {
            print("fetchDataFriendsFromVkServer - done")
        }
    }
    
    // загружаем из RealM
    func loadDataFriendsFromRealm() {
        do {
        let realm = try Realm()
        let friendsFromRealM = realm.objects(UserRealMObject.self)
        self.token = friendsFromRealM.observe({ [weak self] (changes: RealmCollectionChange) in
                guard let self = self, let tableView = self.tableView else { return }
                
                print("Данные изменились!")
                switch changes {
                case .initial:
                    print("initial - done")
                    tableView.reloadData()
                case .update:
                    print("update - done")
                    tableView.reloadData()
                case .error(let error):
                    print(error)
                }
            })
            myFriends = Array(friendsFromRealM)
            
            //сортировка
            if !self.myFriends.isEmpty {
                self.myFriends = self.myFriends.sorted(by: {
                    $0.lastName.lowercased() < $1.lastName.lowercased()
                })
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    // фильтрация списка Друзей
    private func filterFriends(text: String?) {
        guard let text = text, !text.isEmpty else {
            filterListOfFriends = myFriends
            return
        }
        filterListOfFriends = myFriends.filter {
            $0.lastName.lowercased().contains(text.lowercased())
        }
        print("\n Фильтрация выполнена!")
    }
    
    //сортировка списка Друзей
    func setupDataSource() {
        //1 filter friends
        filterFriends(text: searchBar?.text)
        
        //2 create sections of first letters
        let firstLetters = filterListOfFriends.map { String($0.lastName.uppercased().prefix(1)) }
        sections = Array(Set(firstLetters)).sorted()
        
        //3 created cached items for sections
        cachedSectionsItems = [:]
        for section in sections {
            cachedSectionsItems[section] = filterListOfFriends.filter {
                $0.lastName.uppercased().prefix(1) == section
            }
        }
    }
    
    private func getFriend(for indexPath: IndexPath) -> UserRealMObject {
        let sectionLetter = sections[indexPath.section]
        return cachedSectionsItems[sectionLetter]![indexPath.row]
    }
}


//MARK: -> TableView Delegate and DataSource

extension FriendsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionLetter = sections[section]
        return (cachedSectionsItems[sectionLetter] ?? []).count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .darkGray
                
        let label = UILabel()
        label.textColor = .white
        label.text = sections[section]
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        let line1 = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        line1.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        headerView.addSubview(line1)
        headerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendsTableCell {
            
            let friendsInSection = getFriend(for: indexPath)
            cell.configureCell(friend: friendsInSection)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(withIdentifier: "friendPhotoCollectionVC") as? FriendPhotoCollectionViewController else {return}
        
        view.friend = getFriend(for: indexPath)
        print(view.friend?.firstName)
        view.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(view, animated: true)
    }
}


//MARK: -> UISearchBar

extension FriendsTableViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setupDataSource()
        tableView.reloadData()
    }
}


