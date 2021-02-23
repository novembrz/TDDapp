//
//  TaskTests.swift
//  TDDappTests
//
//  Created by Дарья on 19.02.2021.
//

import XCTest
@testable import TDDapp

class TaskTests: XCTestCase {
    
    //Можно ли синициализировать
    func testInitTaskModelWithTitle(){
        let task = TaskModel(title: "Foo")
        XCTAssertNotNil(task)
    }
    
    func testInitTaskModelWithDescription(){
        let task = TaskModel(title: "Foo", description: "Bar")
        XCTAssertNotNil(task)
    }
    
    //проверяем присвоение переменной класса с переменной инициализации
    func testWhenGivenTitleSetsTitle(){
        let task = TaskModel(title: "Foo")
        XCTAssert(task.title == "Foo")
    }
    
    func testWhenGivenDescSetsDesc(){
        let task = TaskModel(title: "Foo", description: "Bar")
        XCTAssert(task.description == "Bar")
    }
    
    func testWhenGivenDateWithDate(){
        let task = TaskModel(title: "Foo")
        XCTAssertNotNil(task.date)
    }
    
    func testWhenGivenLocationWithLocation(){
        let location = Location(title: "Foo")
        let task = TaskModel(title: "Bar", description: "Baz", location: location)
        XCTAssertEqual(location, task.location)
    }

}
