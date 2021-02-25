//
//  NewTaskViewControllerTests.swift
//  TDDappTests
//
//  Created by Дарья on 23.02.2021.
//

import XCTest
import CoreLocation
@testable import TDDapp

class NewTaskViewControllerTests: XCTestCase {
    
    var sut: NewTaskViewController!
    var placemark: MockCLPlacemark!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testViewHasTitleTextField(){
        XCTAssertNotNil(sut.titleTF)
        XCTAssertTrue(sut.titleTF.isDescendant(of: sut.view))
    }
    
    func testViewHasDescriptionTextField(){
        XCTAssertNotNil(sut.descriptionTF)
        XCTAssertTrue(sut.descriptionTF.isDescendant(of: sut.view))
    }
    
    func testViewHasDateTextField(){
        XCTAssertNotNil(sut.dateTF)
        XCTAssertTrue(sut.dateTF.isDescendant(of: sut.view))
    }
    
    func testViewHasLocationTextField(){
        XCTAssertNotNil(sut.locationTF)
        XCTAssertTrue(sut.locationTF.isDescendant(of: sut.view))
    }
    
    func testViewHasAdressTextField(){
        XCTAssertNotNil(sut.addressTF)
        XCTAssertTrue(sut.addressTF.isDescendant(of: sut.view))
    }
    
    func testViewHasSaveButton(){
        XCTAssertNotNil(sut.saveButton)
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func testViewHasCancelButton(){
        XCTAssertNotNil(sut.cancelButton)
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    

    func testSaveUsesGeocoderToConvertCoordinateFromAdress(){
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = df.date(from: "01.01.19")
        
        sut.titleTF.text = "Foo"
        sut.locationTF.text = "Bar"
        sut.dateTF.text = "01.01.19"
        sut.addressTF.text = "Уфа"
        sut.descriptionTF.text = "Baz"
        
        sut.taskManager = TaskManager()
        let mockGeocoder = MockCLGeocoder()
        sut.geocoder = mockGeocoder
        sut.save()
        
        let coordinate = CLLocationCoordinate2D(latitude: 54.7373058, longitude: 55.9722491)
        let location = Location(title: "Bar", coordinate: coordinate)
        let generatedTask = TaskModel(title: "Foo", description: "Baz", date: date, location: location)
        
        placemark = MockCLPlacemark()
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        let task = sut.taskManager.pullTask(at: 0)
        
        XCTAssertEqual(task, generatedTask)
    }
    
    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton
        
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    //корректная работа координат с интернетом. Нужно делать ассинхронно
    func testGeocoderFetchesCorrectCoordinate() {
        let geocoderAnswer = expectation(description: "Geocoder answer")
        let addressString = "Уфа"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            
            let placemark = placemarks?.first
            let location = placemark?.location
            
            guard
                let latitude = location?.coordinate.latitude,
                let longitude = location?.coordinate.longitude else {
                    XCTFail()
                    return
            }
 
            XCTAssertEqual(latitude, 54.7373058)
            XCTAssertEqual(longitude, 55.9722491)
            geocoderAnswer.fulfill() //удовлетворить ожидание
        }
        waitForExpectations(timeout: 5, handler: nil) //мб сервер плохой, инета нет - поэтому ждем
    }
    
}

//MARK: - Mock Classes

extension NewTaskViewControllerTests{
    
    //когда мы используем pullTask, он еще не создался и нам нужно съимитировать комплишн хендлер
    class MockCLGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockCLPlacemark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            return CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}
