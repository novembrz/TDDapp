//
//  DataProviderTests.swift
//  TDDappTests
//
//  Created by Дарья on 22.02.2021.
//

import XCTest
@testable import TDDapp

class DataProviderTests: XCTestCase {
    
    var sut: DataProvider!
    var tableView: UITableView!
    var controller: TaskListViewController!
    
    override func setUpWithError() throws {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: String(describing: TaskListViewController.self))
        controller.loadViewIfNeeded()
        
        sut = DataProvider()
        sut.taskManager = TaskManager()
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        sut = nil
        tableView = nil
        controller = nil
    }
    
    //MARK: - Data Source
    
    // сколько всего секций
    func testNumberOfSectionIsTwo(){
        XCTAssert(tableView.numberOfSections == 2)
    }
    
    // кол-во строк в 1 секции
    func testNumberOfRowsInZeroSections(){
        sut.taskManager?.add(TaskModel(title: "Foo"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.taskManager?.add(TaskModel(title: "Bar"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    // кол-во строк во 2 секции
    func testNumberOfRowsInOneSection(){
        sut.taskManager?.add(TaskModel(title: "Foo"))
        sut.taskManager?.check(at: 0)
        XCTAssert(tableView.numberOfRows(inSection: 1) == 1)
        
        sut.taskManager?.add(TaskModel(title: "Bar"))
        sut.taskManager?.check(at: 0)
        tableView.reloadData()
        XCTAssert(tableView.numberOfRows(inSection: 1) == 2)
    }
    
    //Действительно ли ячейка имеет тип ТаскЦелл
    func testCellForRowIsTaskCell(){
        sut.taskManager?.add(TaskModel(title: "Foo"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TaskCell)
    }
    
    //Проверяем вызвался ли метод переиспользования ячейки
    func testCellForRowIsDequeued(){
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        sut.taskManager?.add(TaskModel(title: "Foo"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellIsDequeued)
    }
    
    //Вызвался ли метод наполнения ячейки
    func testCellForRowsInZeroSectionCalledConfigure(){
        tableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
        
        let task = TaskModel(title: "Foo")
        sut.taskManager?.add(task)
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockTaskCell
        cell.configure(with: task)
        XCTAssert(task == cell.task)
    }
    
    //Добавление одновременно в обе секции тк может быть баг с размером ячейки
    func testCellForRowInSectionOneCallsConfigure() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        let task = TaskModel(title: "Foo")
        let task2 = TaskModel(title: "Bar")
        sut.taskManager?.add(task)
        sut.taskManager?.add(task2)
        sut.taskManager?.check(at: 0)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    //Действительно ли можно удалить из 0 секции и она попадет в 1
    func testCheckTaskChekingInTaskManager(){
        sut.taskManager?.add(TaskModel(title: "Foo"))
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }
    
    //Действительно ли можно удалить из 1 секции и она попадет в 0
    func testUncheckTaskUnchekingInTaskManager(){
        sut.taskManager?.add(TaskModel(title: "Foo"))
        sut.taskManager?.check(at: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
    
    //MARK: - Delegate
    
    //У кнопки удалить в 0 секции название Done?
    func testTitleForDeliteButtonInZeroSectionIsDone(){
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        XCTAssert(buttonTitle == "Done")
    }
    
    //У кнопки удалить в 1 секции название Undone?
    func testTitleForDeliteButtonInOneSectionIsDone(){
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        XCTAssert(buttonTitle == "Undone")
    }
    
}

//MARK: - Mock
extension DataProviderTests{
    
    class MockTableView: UITableView{
        var cellIsDequeued = false
        
        static func mockTableView(withDataSource dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 375, height: 658), style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            return mockTableView
        }
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellIsDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
    
    class MockTaskCell: TaskCell{
        var task: TaskModel!
        
        override func configure(with task: TaskModel, isDone: Bool = false){
            self.task = task
        }
    }
}
