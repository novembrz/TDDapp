//
//  TaskModel.swift
//  TDDapp
//
//  Created by Дарья on 19.02.2021.
//

import Foundation

struct TaskModel{
    let title: String
    let description: String?
    let date: Date
    let location: Location?
    
    init(title: String, description: String? = nil, date: Date? = nil, location: Location? = nil){
        self.title = title
        self.description = description
        self.location = location
        self.date = date ?? Date()
    }
}

extension TaskModel: Equatable {
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        guard lhs.title == rhs.title &&
                lhs.description == rhs.description &&
                lhs.location == rhs.location
        else {return false}
        return true
    }
}
