//
//  FriendsTableVC.swift
//  Homework_1
//
//  Created by Maksim on 22.02.2021.
//
import UIKit
import Foundation
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class FriendsTableViewController: UIViewController {
    
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let apiVkServices = ApiVkServices()
    let realMServices = RealMServices()
    
    //vkUserId
    private var vkUserId: String = "0"

    //RealM Notifications
    var token: NotificationToken?
    
    //Firebase
    private var usersFirebaceInfo = [FirebaseUserInfo]()
    private let ref = Database.database().reference(withPath: "users")
    
    var myFriends:[UserRealMObject] = []

    var filterListOfFriends: [UserRealMObject] = []
    var sections: [String] = []
    var cachedSectionsItems: [String:[UserRealMObject]] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userId = Session.shared.userId else {
                    print("Failed to get vkUserId")
                    return
                }
        self.vkUserId = userId
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //  realm observer
        realMServices.startFriendsRealmObserver(view: self)
        
        //настройка
        configureFriendsTableView()
        
        //adding user to firebase
        FirebaseModel.instance.addUserInfoToFirebase(referenceTo: ref, vkUserId: vkUserId)
        usersFirebaceInfo = FirebaseModel.instance.startFirebaseObserve(referenceTo: ref)
        
        //cloud animation
        startCloudAnimation()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // закрываем token Realm
        super.viewDidDisappear(animated)
        token?.invalidate()
    }
    
    func configureFriendsTableView() {
        //загрузка друзей с сервера vk.com
        fetchDataFriendsFromVkServer()
        
        //Загрузка списка друзей из Realm (рефакторинг)
        myFriends = realMServices.loadDataFriendsFromRealm()

        setupDataSource()
    }
    
    //сортировка друзей
    func sortAlphabeticFriendsArr(){
        myFriends = myFriends.sorted(by: {
            $0.lastName.lowercased() < $1.lastName.lowercased()
        })
    }
    
    // Загрузка данных с сервера //(в RealM) - отдельно
    func fetchDataFriendsFromVkServer() {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("error getting userId")
            return
        }
        
        //версия 2
        //ДЗ №4 - технология использования Promise
        apiVkServices.getUrl(userId: userId, accessToken: accessToken)
            .get({url in
                print("\\ Запрос списка друзей пользователя - ", url)
            })
            .then(on: DispatchQueue.global(), apiVkServices.getData(promisedUrl:))
            .then(apiVkServices.getParsedData(promisedData:))
            .then(apiVkServices.getFriends(promisedItems:))
            .done(on: DispatchQueue.main) { friends in
                print("\\ Получен список друзей - done")
                // save friends to realm
                self.realMServices.saveFriendsData(friends)
             
            }.ensure {
                //TO DO animating
              
            }.catch { error in
                print(error)
            }
        
        //версия 1
//        apiVkServices.getFriends(userId: userId, accessToken: accessToken) {
//            print("fetchDataFriendsFromVkServer - done")
//        }
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
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //guard let view = storyboard.instantiateViewController(withIdentifier: FriendASPhotoCollectionVC.identifier) as? FriendASPhotoCollectionVC else {return}
        let newView = FriendASPhotoCollectionVC()
        
        newView.friend = getFriend(for: indexPath)
        //print(view.friend?.firstName)
        newView.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(newView, animated: true)
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

//MARK: -> cloud animation
extension FriendsTableViewController {
    func startCloudAnimation() {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.addSubview(coverView)
        coverView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        coverView.alpha = 0.6
        UIView.startLoadingCloudAnimation(view: coverView, time: 3)
    }
}

//MARK: -> Добавляем инфу о группах пользователя в Firestore
extension FriendsTableViewController {
    
    // Загрузка данных с сервера (в RealM)
//    func fetchDataGroupsFromVkServer() {
//        guard let userId = Session.shared.userId,
//              let accessToken = Session.shared.token else {
//            print("error getting userId")
//            return
//        }
//        apiVkServices.getUserGroups(userId: userId, accessToken: accessToken)
//        //{
//            print("fetchDataGroupsFromServer - done")
//            self.addUserGroupsInfo()
//        //}
//    }
    
//    func addUserGroupsInfo() {
//        let usersRef = "users"
//            do {
//                // Загружаем группы пользователя из RealM
//                guard let realm = try? Realm() else { return }
//                let groupsFromRealm = realm.objects(GroupsRealMObject.self)
//                let mainUserGroups = Array(groupsFromRealm)
//                var groupsInfoConvertedToFirestore:[Dictionary<String, Any>] = []
//                for element in mainUserGroups {
//                    let id = element.id
//                    let name = element.name
//                    let group = [
//                        "id": id,
//                        "name": name
//                    ] as [String : Any]
//                    groupsInfoConvertedToFirestore.append(group)
//                }
//                // Выгружаем группы пользователя в Firestore
//                Firestore.firestore().collection(usersRef).addDocument(data: [
//                    "userId": Auth.auth().currentUser?.uid ?? "",
//                    "vkUserId": Session.shared.userId,
//                    "groups": groupsInfoConvertedToFirestore
//                ]) { (error) in
//                    if let error = error {
//                        debugPrint("Error #1. adding user info to firestore. \(error.localizedDescription)")
//                    } else {
//                        print("\n\n\nUser info added to firestore - succes")
//                    }
//                    return
//                }
//            } catch {
//                debugPrint(error.localizedDescription)
//            }
//    }
}
