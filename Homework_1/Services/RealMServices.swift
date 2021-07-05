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
    func startFriendsRealmObserver(view:FriendsTableViewController) {
        do {
        let realm = try Realm()
        let friendsFromRealM = realm.objects(UserRealMObject.self)
            view.token = friendsFromRealM.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let self = self, let tableView = view.tableView else { return }
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
    
    // получаем Groups из Realm
    func loadGroupsDataFromRealm() -> [GroupsRealMObject] {
        var groups:[GroupsRealMObject] = []
        do {
            let realm = try Realm()
            let groupsFromRealm = realm.objects(GroupsRealMObject.self)
            groups = Array(groupsFromRealm)
        } catch {
            debugPrint(error.localizedDescription)
        }
        return groups
    }
    
    // observer Realm для MyGroupsTableVC
    func startGroupsRealmObserver(view:MyGroupsTableVC) {
        do {
        let realm = try Realm()
        let groupsFromRealM = realm.objects(GroupsRealMObject.self)
            view.token = groupsFromRealM.observe({ (changes: RealmCollectionChange) in
                switch changes {
                case .initial(let groups):
                    print("initial friends - done")
                    view.myGroups = Array(groups)
                    view.sortGroups()
                    DispatchQueue.main.async {
                        view.tableView.reloadData()
                    }
                case .update(let groups, let deletions, let insertions, let modifications):
//                    DispatchQueue.main.async {
//                        view.tableView.beginUpdates()
//                        view.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                             with: .automatic)
//                        view.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                             with: .automatic)
//                        view.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                             with: .automatic)
//                        view.tableView.endUpdates()
//                    }
                    print("update friends - done")
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
    
    // получаем News из Realm
        func loadNewsDataFromRealm() -> [NewsRealmObject] {
            var news:[NewsRealmObject] = []
            do {
                let realm = try Realm()
                let newsFromRealm = realm.objects(NewsRealmObject.self)
                news = Array(newsFromRealm)
            } catch {
                debugPrint(error.localizedDescription)
            }
            return news
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
    
    //MARK: -> Фотографии - колонка Друзья сохраняем url фото в бд
    func saveUrlPhotosToRealm(_ photos: [PhotoRealMObject]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
                        if realm.objects(PhotoRealMObject.self).count != 0 {
                            _ = try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
                            let oldPhotosRequest = realm.objects(PhotoRealMObject.self)
                            realm.beginWrite()
                            realm.delete(oldPhotosRequest)
                            try realm.commitWrite()
                            print("/n/n/n oldPhotosRequest - deleted")
                        }
            realm.beginWrite()
            realm.add(photos, update: .all)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func clearPhotoRealm() {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
            
            if realm.objects(PhotoRealMObject.self).count != 0 {
                _ = try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
                let oldPhotosRequest = realm.objects(PhotoRealMObject.self)
                realm.beginWrite()
                realm.delete(oldPhotosRequest)
                try realm.commitWrite()
                print("/n/n/n oldPhotosRequest - deleted")
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
}
