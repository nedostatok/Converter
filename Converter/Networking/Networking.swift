//
//  Networking.swift
//  Converter
//
//  Created by User on 26.01.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    typealias HandlerForCurrency = (Result<[Currency],NSError>) -> ()
    typealias HandlerForExchange = (Result<Rate,NSError>) -> ()
    
    func loadCurrency(completion: @escaping HandlerForCurrency) {
        guard let url = URL(string: "https://free.currconv.com/api/v7/currencies?apiKey=c8fd8d355dbd31782bea") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, respinse, error) in
            
            guard error == nil else {
                let taskError = NSError(domain: "domain", code: ErrorCode.taskError.rawValue, userInfo: nil)
                completion(.failure(taskError))
                return
            }
            
            guard let data = data else {
                let emptyData = NSError(domain: "domain", code: ErrorCode.emptyData.rawValue, userInfo: nil)
                completion(.failure(emptyData))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                guard let currencies = json["results"] as? [String:Any] else { return }
                
                var currencyArray = [Currency]()
                for i in currencies.keys {
                    currencyArray.append(Currency(id: i))
                }
                completion(.success(currencyArray))
                
            } catch {
                let parseError = NSError(domain: "domain", code: ErrorCode.parseError.rawValue, userInfo: nil)
                completion(.failure(parseError))
            }
        }.resume()
    }
    
    func loadExchangeRate(from: String, to: String, comletion: @escaping HandlerForExchange) {
        
        guard let url = URL(string: "https://free.currconv.com/api/v7/convert?q=\(from)_\(to)&compact=ultra&apiKey=c8fd8d355dbd31782bea") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                let taskError = NSError(domain: "domain", code: ErrorCode.taskError.rawValue, userInfo: nil)
                comletion(.failure(taskError))
                return
            }
            
            guard let data = data else {
                let emptyData = NSError(domain: "domain", code: ErrorCode.emptyData.rawValue, userInfo: nil)
                comletion(.failure(emptyData))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
                
                for (_, value) in json {
                    if let value = value as? Double {
                        comletion(.success(Rate(result: value)))
                    }
                }
            } catch {
                let parseError = NSError(domain: "domain", code: ErrorCode.parseError.rawValue, userInfo: nil)
                comletion(.failure(parseError))
            }
        }.resume()
    }
}
