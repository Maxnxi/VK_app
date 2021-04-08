//
//  ListOfLettersOnFriends.swift
//  Homework_1
//
//  Created by Maksim on 03.03.2021.
//

import UIKit
import Foundation

@IBDesignable
class ListOfLettersOnFriends: UIControl {

    //var letters:[String] = []
    var sortedLets:[String] = []
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    var selectedLetter: String? = nil {
        didSet {
            updateSelectedLetter()
            self.sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
       
    func configureView(letters:[String]) {
        self.sortedLets = letters
        print(#function)
        print("а вот и буквы: ", letters)
        setupView()
        
    }
    
    
        
    private func setupView() {
        
        //sortedLets = Friend.sortLetters(letters: letters)
        
        print("кол-во букв: ",sortedLets.count)
        for letter in sortedLets {
            //let button = UIButton(type: .system)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            button.setTitle(letter, for: .normal)
            button.setTitleColor(.white, for: .normal)
            //button.setTitleColor(.lightGray, for: .selected)
            button.setTitleShadowColor(.lightGray, for: .normal)
            button.addTarget(self, action: #selector(selectLetter), for: .touchUpInside)
            
            buttons.append(button)
        }
        print("\n количество кнопок ",buttons.count)
        stackView = UIStackView(arrangedSubviews: buttons)
        self.addSubview(stackView)
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
    }
    
    @objc func selectLetter(_ sender: UIButton){
        //print(#function)
       // print(buttons.hashValue)
        guard let index = self.buttons.firstIndex(of: sender) else { return}
        guard let letter = buttons[index].currentTitle else {return}
        self.selectedLetter = letter
        print(letter)
        
        FriendsTableVC.instance.setSelectedLetter(letter: letter)
        
        //setSelectedLetter
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = CGRect(x: 0, y:  bounds.midY-CGFloat((20*buttons.count)/2), width: 20, height: CGFloat(20*buttons.count))
    }
    
    private func updateSelectedLetter(){
        for (index, button) in self.buttons.enumerated() {
            guard let letter = buttons[index].currentTitle else {continue}
            button.isSelected = letter == selectedLetter
        }
    }
}
