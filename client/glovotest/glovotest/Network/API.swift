//
//  API.swift
//  glovotest
//
//  Created by Jesús Solé on 15/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//

import UIKit
import ReactiveKit
import Alamofire
import AlamofireObjectMapper

class API: NSObject {
    
    static let manager = API()
    
    private func getCities(completion: @escaping (ReactiveKit.Result<[CityModel], ClientError>) -> Void) -> DataRequest {
        
        let URL = Network.baseUrl + Network.cities
        return Alamofire.request(URL).responseArray { (response: DataResponse<[CityModel]>) in
            
            if let citiesArray = response.result.value {
                completion(ReactiveKit.Result<[CityModel], ClientError>(citiesArray))
            } else {
                completion(ReactiveKit.Result<[CityModel], ClientError>(.error))
            }
        }
    }
    
    func getCities() -> Signal<[CityModel], ClientError> {
        return Signal { observer in
            let task = self.getCities(completion: { result in
                switch result {
                case .success(let cities):
                    observer.next(cities)
                    observer.completed()
                case .failure(let error):
                    observer.failed(error)
                }
            })
            
            return BlockDisposable {
                task.cancel()
            }
        }
    }
    
    private func getCityInfo(code: String, completion: @escaping (ReactiveKit.Result<CityModel, ClientError>) -> Void) -> DataRequest {
        
        let URL = Network.baseUrl + Network.cities + code
        return Alamofire.request(URL).responseObject { (response: DataResponse<CityModel>) in
            
            if let cityInfo = response.result.value {
                completion(ReactiveKit.Result<CityModel, ClientError>(cityInfo))
            } else {
                completion(ReactiveKit.Result<CityModel, ClientError>(.error))
            }
        }
    }
    
    func getCityInfo(code: String) -> Signal<CityModel, ClientError> {
        return Signal { observer in
            let task = self.getCityInfo(code: code, completion: { result in
                switch result {
                case .success(let city):
                    observer.next(city)
                    observer.completed()
                case .failure(let error):
                    observer.failed(error)
                }
            })
            
            return BlockDisposable {
                task.cancel()
            }
        }
    }
    
    private func getCountries(completion: @escaping (ReactiveKit.Result<[CountryModel], ClientError>) -> Void) -> DataRequest {
        
        let URL = Network.baseUrl + Network.countries
        return Alamofire.request(URL).responseArray { (response: DataResponse<[CountryModel]>) in
            
            if let countriesArray = response.result.value {
                completion(ReactiveKit.Result<[CountryModel], ClientError>(countriesArray))
            } else {
                completion(ReactiveKit.Result<[CountryModel], ClientError>(.error))
            }
        }
    }
    
    func getCountries() -> Signal<[CountryModel], ClientError> {
        return Signal { observer in
            let task = self.getCountries(completion: { result in
                switch result {
                case .success(let countries):
                    observer.next(countries)
                    observer.completed()
                case .failure(let error):
                    observer.failed(error)
                }
            })
            
            return BlockDisposable {
                task.cancel()
            }
        }
    }
}
