//
//  ApiService.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation
import RealmSwift

class ApiService : NSObject {
    private let baseUrl = ""
    
    private let sourcesURL = URL(string: "https://api.restful-api.dev/objects")!
    
    func fetchDeviceDetails(completion : @escaping ([DeviceData], Bool) -> ()){
        let realm = Realm.cache
        let cachedDevices = Array(realm.objects(DeviceData.self))
        if(!cachedDevices.isEmpty) {
            print("got devices from cache")
            completion(cachedDevices, true)
        }else{
            URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    completion([], false) // Return an empty array on network failure
                    return
                }
                
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    let empData = try! jsonDecoder.decode([DeviceData].self, from: data)
                    DispatchQueue.main.async {
                        DeviceDataRW.addToCache(empData)
                    }
                    if (empData.isEmpty) {
                        completion([], false)
                    }else{
                        completion(empData, false)
                    }
                }
            }.resume()
        }
    }
}
