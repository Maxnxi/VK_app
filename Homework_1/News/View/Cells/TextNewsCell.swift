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
        setCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCell()
        
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
    
    func setCell() {
        
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

        // Configure the view for the selected state
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
            //self.reloadInputViews()
            //self.contentView.reloadInputViews()
        } else {
            textNewsLbl.numberOfLines = 4
            showStatusMore = false
            showMoreLessBtn.setTitle("show more", for: .normal)
            self.setNeedsDisplay()
            
            //self.reloadInputViews()
            //self.contentView.reloadInputViews()
        }
    }
    
}
