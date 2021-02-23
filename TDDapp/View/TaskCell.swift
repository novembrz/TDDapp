//
//  TaskCell.swift
//  TDDapp
//
//  Created by Дарья on 22.02.2021.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dddd, dd MMMM yyyy"
        df.locale = Locale(identifier: "ru_RU")
        return df
    }
    
    func configure(with task: TaskModel, isDone: Bool = false){
        
        if isDone == false{
            self.titleLabel.text = task.title
            
            let date = dateFormatter.string(from: task.date)
            dateLabel.text = date
            
            if let location = task.location{
                let title = location.title
                locationLabel.text = title
            }
        } else {
            let attString = NSAttributedString(string: task.title, attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            
            titleLabel.attributedText = attString
            dateLabel = nil
            locationLabel = nil
        }
    }
}
