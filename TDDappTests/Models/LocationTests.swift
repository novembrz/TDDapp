//
//  LocationTests.swift
//  TDDappTests
//
//  Created by Дарья on 19.02.2021.
//

import XCTest
import CoreLocation
@testable import TDDapp

class LocationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitLocationWithTitle(){
        let location = Location(title: "Foo")
        XCTAssertNotNil(location)
    }
    
    func testWhenGivenTitleSetTitle(){
        let location = Location(title: "Foo")
        XCTAssertEqual(location.title, "Foo")
    }
    
    func testInitLocationWithCoordinate(){
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(title: "Foo", coordinate: coordinate)
        XCTAssertNotNil(location)
    }
    
    func testWhenGivenCoordinateSetCoordinate(){
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(title: "Foo", coordinate: coordinate)
        XCTAssertEqual(coordinate.longitude, location.coordinate?.longitude)
        XCTAssertEqual(coordinate.latitude, location.coordinate?.latitude)
    }

}
