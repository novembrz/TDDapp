//
//  TaskManagerTests.swift
//  TDDappTests
//
//  Created by Дарья on 19.02.2021.
//

import XCTest
@testable import TDDapp

class TaskManagerTests: XCTestCase {
    
    var sut: TaskManager!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = TaskManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testInitTaskManagerWithoutTasksCount(){
        XCTAssert(sut.tasksCount == 0)
    }
    
    func testInitTaskManagerWithoutDoneTasksCount(){
        XCTAssert(sut.doneTasksCount == 0)
    }
    
    func testAddedTaskIncreamentTasksCount(){
        let task = TaskModel(title: "Foo")
        sut.add(task)
        XCTAssert(sut.tasksCount == 1)
    }
    
    func testCheckTaskChangesCounts(){
        let task = TaskModel(title: "Foo")
        sut.add(task)
        sut.check(at: 0)
        XCTAssert(sut.tasksCount == 0)
        XCTAssert(sut.doneTasksCount == 1)
    }
    
    func testTaskAtIndexIsAddedTask(){
        let task = TaskModel(title: "Foo")
        sut.add(task)
        let pullTask = sut.pullTask(at: 0)
        XCTAssertEqual(task, pullTask)
    }
    
    func testCheckedTaskRemovedFromTasks(){
        let task = TaskModel(title: "Foo")
        let task2 = TaskModel(title: "Bar")
        sut.add(task)
        sut.add(task2)
        
        sut.check(at: 0)
        
        let pullTask = sut.pullTask(at: 0)
        XCTAssertEqual(task2, pullTask)
    }
    
    func testRemoveTaskIsAddedDoneTask(){
        let task = TaskModel(title: "Foo")
        sut.add(task)
        sut.check(at: 0)
        
        let doneTask = sut.pullDoneTask(at: 0)
        XCTAssertEqual(task, doneTask)
    }
    
    func testRemoveAllResultsCountsBeZero(){
        sut.add(TaskModel(title: "Foo"))
        sut.add(TaskModel(title: "Bar"))
        sut.check(at: 0)
        sut.removeAll()
        XCTAssert(sut.tasksCount == 0)
        XCTAssert(sut.doneTasksCount == 0)
    }
    
    func testAddedTaskIsntEqualTaskInTasks(){
        sut.add(TaskModel(title: "Foo"))
        sut.add(TaskModel(title: "Foo"))
        
        XCTAssert(sut.tasksCount == 1)
    }

}
