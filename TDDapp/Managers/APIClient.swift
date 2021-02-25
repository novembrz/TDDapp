//
//  APIClient.swift
//  TDDapp
//
//  Created by dasha on 25.02.2021.
//

import Foundation

//мы работаем не с реальным сервером поэтому ошибке неоткуда приходить
enum NetworkError: Error{
    case emptyData
}

//для MockURLSessionDataTask
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol{}

class APIClient{
    
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(withName name: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        
        //символы которые нужны для пароля и их не нужно энкодить(они часть пароля пользователя и нужны в таком же виде). Точное описание методов посмотри на стековерфлоу
        let allowedCharacters = CharacterSet.urlQueryAllowed // разрешены все символы кроме некоторых
        
        guard
            let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
            let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        else {fatalError()}
        
        let query = "name=\(name)&password=\(password)"
        guard let url = URL(string: "https://todoapp.com/login?\(query)") else {fatalError()}
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return completionHandler(nil, error) // for testLoginWhenResponseErrorReturnsError
            }
            
            do{
                guard let data = data else {
                    completionHandler(nil, NetworkError.emptyData) //for testLoginWhenDataIsNilReturnsError()
                    return
                }
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String] //токен это словарь
                let token = dict["token"] //for testSuccessfullLoginCtreatesToken
                completionHandler(token, nil)
            }catch{
                completionHandler(nil, error) //for testLoginInvalidReturnedError
            }
        }
        task.resume()
    }
}
