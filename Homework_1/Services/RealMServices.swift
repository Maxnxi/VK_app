//
//  RealMServices.swift
//  Homework_1
//
//  Created by Maksim on 26.04.2021.
//
import Foundation
import RealmSwift

class RealMServices {
    
    //MARK: -> колонка Дркзья (Friends)
    //Сохряняем друзей в бд
    func saveFriendsData(_ users: [UserRealMObject]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(users, update: .all)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func loadDataFriendsFromRealm() -> [UserRealMObject] {
        var friends:[UserRealMObject] = []
        do {
            let realm = try Realm()
            let friendsFromRealM = realm.objects(UserRealMObject.self)
            friends = Array(friendsFromRealM)
        } catch {
            debugPrint(error.localizedDescription)
        }
        return friends
    }
    
    // observer Realm для FriendsTableViewController
    func startFriendsRealmObserver(view: FriendsTableViewController) {
        do {
        let realm = try Realm()
        let friendsFromRealM = realm.objects(UserRealMObject.self)
            view.token = friendsFromRealM.observe({ (changes: RealmCollectionChange) in
            
                switch changes {
                case .initial(let friends):
                    print("initial friends - done")
                    view.myFriends = Array(friends)
                    view.sortAlphabeticFriendsArr()
                    DispatchQueue.main.async {
                        view.tableView.reloadData()
                    }
                case .update(let friends,_,_,_):
                    print("update friends - done")
                    view.myFriends = Array(friends)
                    view.sortAlphabeticFriendsArr()
                    DispatchQueue.main.async {
                        view.tableView.reloadData()
                    }
                case .error(let error):
                    print(error)
                }
            })
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: -> колонка Группы (Groups)
    func saveGroupsData(_ groups: [GroupsRealMObject]) {
        do {
              let realm = try Realm()
            realm.beginWrite()
            realm.add(groups, update: .all)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    // observer Realm для MyGroupsTableVC
    func startGroupsRealmObserver(view:MyGroupsTableVC) {
        do {
        let realm = try Realm()
        let groupsFromRealM = realm.objects(GroupsRealMObject.self)
            view.token = groupsFromRealM.observe({ (changes: RealmCollectionChange) in
                switch changes {
                case .initial(let groups):
                    print("initial groups - done")
                    view.myGroups = Array(groups)
                    view.sortGroups()
                    DispatchQueue.main.async {
                        view.tableView.reloadData()
                    }
                case .update(let groups, _, _, _):
                    print("update groups - done")
                    view.myGroups = Array(groups)
                    view.sortGroups()
                    DispatchQueue.main.async {
                        view.tableView.reloadData()
                    }
                case .error(let error):
                    print(error)
                }
            })
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    
    //MARK: -> колонка Новости (News)
    //сохраняем News в Realm
    func saveNewsData(_ news: [NewsRealmObject]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(news, update: .all)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    // realm observer к News
    func startNewsRealmObserver(view:NewsVC) {
        do {
        let realm = try Realm()
            let newsFromRealM = realm.objects(NewsRealmObject.self)
            view.token = newsFromRealM.observe({ (changes: RealmCollectionChange) in
                switch changes {
                case .initial(let news):
                    print("initial news - done")
                    let newsTmp = view.sortNewsByDate(news: Array(news))
                    view.myNews = Array(newsTmp)
                    DispatchQueue.main.async {
                        view.tableView.reloadData()
                    }
                case .update(let news,_,_,_):
                    print("update news - done")
                    // в зависимости от паттерна infinite scrolling или pull-request
                    if view.isTableViewScrolling == false {
                        let newsTmp = view.sortNewsByDate(news: Array(news))
                        view.myNews = Array(newsTmp)
                        DispatchQueue.main.async {
                            view.tableView.reloadData()
                        }
                    } else if view.isTableViewScrolling == true {
                        let newsPreCount = view.myNews.count
                        let newsTmp = view.sortNewsByDate(news: Array(news))
                        view.myNews.append(contentsOf: newsTmp)
                        let newsAfterCount = view.myNews.count
                        view.isTableViewScrolling = false
                        DispatchQueue.main.async {
                            let indexSet = IndexSet(integersIn: newsPreCount..<newsAfterCount)
                            view.tableView.insertSections(indexSet, with: .automatic)
                        }
                    }
                case .error(let error):
                    print(error)
                }
            })
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
