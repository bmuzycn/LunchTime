//
//  Networking.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//
//  Using the decoder method in swift 4 to parse json data


import Foundation
class NetworkHelper {
    
    //MARK: using a completion callback to pass json data after internet fetching is completed
    
    static func getData(completionHandler: @escaping ([Any]?) -> Void) {
        
        let stringURL = "https://s3.amazonaws.com/br-codingexams/restaurants.json"
        
        //Another solution is using a sync dispatch blocks the main thread
        //let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: stringURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, err) in
            
            if let resp = response as? HTTPURLResponse {
                print(resp.statusCode)
            }
            
            guard let data = data else { return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let json = try jsonDecoder.decode(Restaurants.self, from: data)
                let result = json.restaurants
                completionHandler(result)
                
                //semaphore.signal()
            } catch {
                print(error)
            }
            
        }
        task.resume()
        //let timeoutResult = semaphore.wait(timeout: .distantFuture)
        //print(timeoutResult)
    }
}

struct Restaurants: Codable {
    let restaurants : [Restaurant]
}

struct Restaurant: Codable {
    let name: String
    let backgroundImageURL: URL
    let category: String
    let contact: Contact?
    let location: Location
}

struct Contact: Codable {
    let phone: String
    let formattedPhone: String
    let twitter: String?
}

struct Location: Codable {
    let address: String
    let crossStreet: String?
    let lat: Double
    let lng: Double
    let postalCode: String?
    let cc: String
    let city: String
    let state: String
    let country: String
    let formattedAddress: [String]
}


