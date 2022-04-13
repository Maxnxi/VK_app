//
//  TextNewsCell.swift
//  Homework_1
//
//  Created by Maksim on 03.06.2021.
//

import UIKit

class TextNewsCell: UITableViewCell {

    @IBOutlet weak var textNewsLbl: UILabel!
    @IBOutlet weak var showMoreLessBtn: UIButton!
    
    static var nibName: String = "TextNewsCell"
    static var reuseIdentifierOfCellNews: String = "textNewsCell"
    
    private var showStatusMore = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("number of lines - ", textNewsLbl.numberOfLines)
        if showStatusMore == false {
        textNewsLbl.numberOfLines = 4
        } else {
            textNewsLbl.numberOfLines = 0
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        if showStatusMore == false {
        textNewsLbl.numberOfLines = 4
        } else {
            textNewsLbl.numberOfLines = 0
        }
        textNewsLbl.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(newsText: String) {
        self.textNewsLbl.text = newsText
    }
    
    @IBAction func snowMoreLessBtnWasPressed(_ sender: Any) {
        if showStatusMore == false {
            textNewsLbl.numberOfLines = 0
            showStatusMore = true
            showMoreLessBtn.setTitle("show less", for: .normal)
            self.setNeedsDisplay()
        } else {
            textNewsLbl.numberOfLines = 4
            showStatusMore = false
            showMoreLessBtn.setTitle("show more", for: .normal)
            self.setNeedsDisplay()
        }
    }
    
}
