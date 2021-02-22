//
//  TaskManager.swift
//  TDDapp
//
//  Created by Дарья on 19.02.2021.
//

import Foundation

class TaskManager {
    
    private var tasks: [TaskModel] = []
    private var doneTasks: [TaskModel] = []
    
    var tasksCount: Int {
        return tasks.count
    }
    var doneTasksCount: Int {
        return doneTasks.count
    }
    
    func add(_ task: TaskModel){
        if !tasks.contains(task){
            tasks.append(task)
        }
    }
    
    func check(at index: Int){
        let task = tasks.remove(at: index)
        doneTasks.append(task)
    }
    
    func uncheck(at index: Int){
        let task = doneTasks.remove(at: index)
        tasks.append(task)
    }
    
    func pullTask(at index: Int) -> TaskModel{
        return tasks[index]
    }
    
    func pullDoneTask(at index: Int) -> TaskModel{
        return doneTasks[index]
    }
    
    func removeAll(){
        tasks.removeAll()
        doneTasks.removeAll()
    }
}

