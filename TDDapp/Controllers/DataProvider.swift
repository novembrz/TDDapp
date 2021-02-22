//
//  DataProvider.swift
//  TDDapp
//
//  Created by Дарья on 19.02.2021.
//

import UIKit

enum Sections: Int, CaseIterable{
    case todo, done
}

class DataProvider: NSObject{
    var taskManager: TaskManager?
}

//MARK: - UITableViewDataSource

extension DataProvider: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else {fatalError()}
        guard let taskManager = taskManager else {return 0}
        
        switch section{
        case .todo: return taskManager.tasksCount
        case .done: return taskManager.doneTasksCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: indexPath) as! TaskCell
        
        guard let taskManager = taskManager else {return UITableViewCell()}
        guard let section = Sections(rawValue: indexPath.section) else {fatalError()}
        
        let task: TaskModel!
        switch section{
        case .todo:
            task = taskManager.pullTask(at: indexPath.row)
        case .done:
            task = taskManager.pullDoneTask(at: indexPath.row)
        }
        
        cell.configure(with: task)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let taskManager = taskManager, let section = Sections(rawValue: indexPath.section) else {fatalError()}
        
        switch section{
        case .todo: taskManager.check(at: indexPath.row)
        case .done: taskManager.uncheck(at: indexPath.row)
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate
extension DataProvider: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let section = Sections(rawValue: indexPath.section) else {fatalError()}
        switch section{
        case .todo: return "Done"
        case .done: return "Undone"
        }
    }
}
