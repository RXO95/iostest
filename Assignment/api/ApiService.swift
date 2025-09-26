//
//  ApiService.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation

class ApiService{
    private let baseUrl = "https://api.restful-api.dev/objects"
    
    func fetchDeviceDetails(completion : @escaping ([DeviceData]) -> ()){
        guard let sourcesURL = URL(string: baseUrl) else{
            print("Error")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([]) // Return an empty array on network failure
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            do {
                let empData = try JSONDecoder().decode([DeviceData].self, from: data)
                DispatchQueue.main.async {
                    completion(empData)
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }}
