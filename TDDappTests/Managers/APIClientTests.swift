//
//  APIClientTests.swift
//  TDDappTests
//
//  Created by dasha on 25.02.2021.
//

import XCTest
@testable import TDDapp

class APIClientTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var sut: APIClient!

    override func setUpWithError() throws {
        //у нас нет сервиса но нам нужен юрл, поэтому создаем фейк и дальше как обычно
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut = APIClient()
        sut.urlSession = mockURLSession
    }

    override func tearDownWithError() throws {
        sut = nil
        mockURLSession = nil
    }
    
    //MARK: URL-адресс
    func userLogin(){
        let completionHandler = {(token: String?, error: Error?) in }
        sut.login(withName: "name", password: "%qwerty", completionHandler: completionHandler)
    }
    
    //Правильный ли хост используем, когда юзер пытается залогиниться
    func testLoginUsesCorrectHost(){
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.com")
    }
    
    //Правильный ли пасс используем
    func testLoginUsesCorrectPath(){
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    //Правильные ли запросы передаем в параметры
    
    func testLoginUsesExpectedQuery(){
        
        userLogin()
        
        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")//если пароль с символом то все сломается тк символ имеет смысл в адресах. для этого написала AllowedCharacters
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
    
    //MARK: Token
    //генерируется ли токен при успешной авторизации
    //нужно якобы получить токен и загрузить его на сервер
    // token в Data, она в compHandler, он в DataTask -> он в URLSession
    func testSuccessfullLoginCtreatesToken(){
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)// stub - объект который вернулся с сервера - заготовленный ответ token тк сервера нет// обратный слеш \ это трансформация в строку
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        let tokenExpectation = expectation(description: "Token expectation") //тк работаем с комплишином => тут ожидание
        
        //нам нужен токен, вытаскиваем его наружу из метода логин
        var coughtToken: String?
        sut.login(withName: "name", password: "password") { token, _ in
            coughtToken = token
            tokenExpectation.fulfill() //вызываем ожидание
        }
        waitForExpectations(timeout: 1) { _ in //говорим сколько ждать
            XCTAssertEqual(coughtToken, "tokenString")
        }
    }
    
    // Сразу пришла ошибка, что делать
    func testLoginWhenResponseErrorReturnsError(){
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let error = NSError(domain: "Server error", code: 404, userInfo: nil)
        
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: error)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    //MARK: Parse JSON
    
    //Приходит ли ошибка, когда неверный джейсон приходит(неверный формат)
    func testLoginInvalidReturnedError(){
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        
        let errorExpectation = expectation(description: "Token expectation")
        
        var coughtError: Error?
        sut.login(withName: "name", password: "password") { (token, error) in
            coughtError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(coughtError)
        }
    }
    
    //Приходит ли ошибка когда джейсон вообще не приходит
    func testLoginWhenDataIsNilReturnsError(){
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.urlSession = mockURLSession
        
        let errorExpectation = expectation(description: "Error expectation")
        
        var coughtError: Error?
        sut.login(withName: "name", password: "password") { (token, error) in
            coughtError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(coughtError)
        }
    }
    
}

//MARK: - Mock

extension APIClientTests{
    
    class MockURLSession: URLSessionProtocol {
        
        var url: URL?
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true) //разбили на компоненты для проверки
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?){
            mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?){
            self.responseError = responseError
            self.data = data
            self.urlResponse = urlResponse
        }
        
        override func resume(){
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
        
    }
}
