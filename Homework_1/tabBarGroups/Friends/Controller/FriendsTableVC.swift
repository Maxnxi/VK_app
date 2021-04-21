//
//  FriendsTableVC.swift
//  Homework_1
//
//  Created by Maksim on 22.02.2021.
//
import UIKit
import Foundation

class FriendsTableVC: UIViewController  {
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lettersView: ListOfLettersOnFriends!
    @IBOutlet weak var tableView: UITableView!

    static let instance = FriendsTableVC()
    
    var selectedLetterToScroll: String = "" {
        didSet{
            print(selectedLetterToScroll)
            //self.scroolTableToLetter(letter: selectedLetterToScroll)
        }
    }
    
    public func setSelectedLetter(letter: String) {
        self.selectedLetterToScroll = letter
    }
    
    
    
    var friends:[User] = []
    
    var filterListOfFriends: [User] = []
    var sections: [String] = []
    var cachedSectionsItems: [String:[User]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        repeat {
            sleep(4)
            configureFriendsTableView()
        } while (friends.isEmpty) //?
    }
    
    func configureFriendsTableView() {
        loadFriends()
        setupDataSource()
        //lettersView.configureView(letters: sections)
        tableView.reloadData()
    }
    
    func loadFriends() {
        friends = ALL_MY_FRIENDS
        //print(friends[1].firstName)
        print("friends pushed to FriendsTableVC", friends.count)
        friends = friends.sorted(by: {
            $0.lastName.lowercased() < $1.lastName.lowercased()
        })
    }

    //MARK: -> Data
    
    private func filterFriends(text: String?) {
        guard let text = text, !text.isEmpty else {
            filterListOfFriends = friends
            return
        }
        filterListOfFriends = friends.filter {
            $0.lastName.lowercased().contains(text.lowercased())
        }
        print("\n Фильтрация выполнена!")
    }
    
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
    
    private func getFriend(for indexPath: IndexPath) -> User {
        let sectionLetter = sections[indexPath.section]
        return cachedSectionsItems[sectionLetter]![indexPath.row]
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let controller = segue.destination as? FriendPhotoCollectionVC, let indexPath = tableView.indexPathForSelectedRow {
//            controller.friend = friends[indexPath.row]
//        }
//    }
}

//MARK: -> TableView

extension FriendsTableVC: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let view = storyboard.instantiateViewController(withIdentifier: "friendPhotoCollectionVC") as? FriendPhotoCollectionVC else {return}
        
        view.friend = getFriend(for: indexPath)
        print(view.friend?.firstName)
        view.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(view, animated: true)
        
        //present(view, animated: true, completion: nil)
    }
    
    
    // НЕ работает
//    func scroolTableToLetter(letter: String) {
//        var sectionIndex: Int?
//        print(letter)
//
//        print(sections)
//        for i in sections {
//            if !i.contains(letter) {
//
//                print(i.lowercased())
//            } else {
//                sectionIndex = sections.firstIndex(of: i)
//                print(i.lowercased())
//            }
//        }
//        print(sectionIndex)
////        var indxs = IndexPath()
////        indxs.section = sectionIndex ?? 0
////        self.tableView.scrollToRow(at: indxs, at: .top, animated: true)
//    }
    
}

//MARK: -> UISearchBar

extension FriendsTableVC: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setupDataSource()
        tableView.reloadData()
    }
    
}


