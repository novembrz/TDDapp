//
//  TaskCellTests.swift
//  TDDappTests
//
//  Created by Дарья on 22.02.2021.
//

import XCTest
@testable import TDDapp

class TaskCellTests: XCTestCase {
    
    var cell: TaskCell!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as! TaskListViewController
        controller.loadViewIfNeeded()
        
        let tableView = controller.tableView
        let dataSource = FakeDataSource()
        tableView?.dataSource = dataSource
        
        cell = tableView?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as? TaskCell
    }

    override func tearDownWithError() throws {
        cell = nil
    }
    
    // Есть ли лейбл в целл
    func testTaskCellHasTitleLabel(){
        XCTAssertNotNil(cell.titleLabel)
    }
    
    // Добавлен ли лейбл на вью
    func testCellsTitleLableIsContentView(){
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func testTaskCellHasLocationLabel(){
        XCTAssertNotNil(cell.locationLabel)
    }
    
    func testCellsLocationLableIsContentView(){
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func testTaskCellHasDateLabel(){
        XCTAssertNotNil(cell.dateLabel)
    }
    
    func testCellsDateLableIsContentView(){
        XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
    }
    
    //Присваевается ли названия при вызове configure
    func testConfigureSetsTitle(){
        let task = TaskModel(title: "Foo")
        cell.configure(with: task)
        
        XCTAssert(task.title == cell.titleLabel.text)
    }
    
    func testConfigureSetsLocation(){
        let location = Location(title: "Foo")
        let task = TaskModel(title: "Bar", location: location)
        cell.configure(with: task)
        
        XCTAssert(task.location!.title == cell.locationLabel.text)
    }
    
    func testConfigureSetsDate(){
        let task = TaskModel(title: "Foo")
        cell.configure(with: task)
        
        let df = DateFormatter()
        df.dateFormat = "dd MMMM yyyy"
        df.locale = Locale(identifier: "ru_RU")
        let date = df.string(from: task.date)
        
        XCTAssert(date == cell.dateLabel.text)
    }
    
    //Зачеркивается ли тайтл при выполнении задания?
    func testSetsAttributeWhenTaskIsDone(){
        let task = TaskModel(title: "Foo")
        cell.configure(with: task, isDone: true)
        let attString = NSAttributedString(string: "Foo", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        XCTAssertEqual(cell.titleLabel.attributedText, attString)
    }
    
    // Удаляются ли локация и дата при выполнении задания?
    func testLocationAndDateLabelIsNilWhenTaskIsDone(){
        let task = TaskModel(title: "Foo")
        cell.configure(with: task, isDone: true)
        
        XCTAssertNil(cell.locationLabel)
        XCTAssertNil(cell.dateLabel)
    }
}

//MARK: - FakeDataSource

extension TaskCellTests {
    
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
