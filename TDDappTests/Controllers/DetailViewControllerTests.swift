//
//  DetailViewControllerTests.swift
//  TDDappTests
//
//  Created by Дарья on 23.02.2021.
//

import XCTest
import CoreLocation
@testable import TDDapp

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testViewHasTitleLabel(){
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }
    
    func testViewHasDescriptionLabel(){
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    func testViewHasDateLabel(){
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    func testViewHasLocationLabel(){
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }
    
    func testViewHasMapView(){
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }
    
    func setupTaskAndAppearanceTransition(){
        let coordinate = CLLocationCoordinate2D(latitude: 55.72726113, longitude: 37.62772322)
        let location = Location(title: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1546300800)
        let task = TaskModel(title: "Foo", description: "Bar", date: date, location: location)
        
        sut.task = task
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    func testSettingTaskSetsTitleLabel(){
        setupTaskAndAppearanceTransition()
        XCTAssertTrue(sut.titleLabel.text == "Foo")
    }
    
    func testSettingTaskSetsDescriptionLabel(){
        setupTaskAndAppearanceTransition()
        XCTAssertTrue(sut.descriptionLabel.text == "Bar")
    }
    
    func testSettingTaskSetsLocationLabel(){
        setupTaskAndAppearanceTransition()
        XCTAssertTrue(sut.locationLabel.text == "Baz")
    }
    
    func testSettingTaskSetsDateLabel(){
        setupTaskAndAppearanceTransition()
        XCTAssertTrue(sut.dateLabel.text == "01.01.19")
    }
    
    func testSettingTaskSetsMapView(){
        setupTaskAndAppearanceTransition()
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 55.72726113, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, 37.62772322, accuracy: 0.001)
    }
}
