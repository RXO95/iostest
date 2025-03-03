//
//  ContentViewModel.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation
import RealmSwift


class ContentViewModel : ObservableObject {
    
    private let apiService = ApiService()
    @Published var navigateDetail: DeviceData? = nil
    @Published var data: [DeviceData]? = []
    @Published var isFromCache = false

    init() {
        print("VM init")
        fetchAPI()
    }
    
    func fetchAPI() {
        print("fetch Api called")
        apiService.fetchDeviceDetails(completion: { item, isFromCache  in
            DispatchQueue.main.async {
                self.data = item
                self.isFromCache = isFromCache
            }
        })
    }
    func navigateToDetail(navigateDetail: DeviceData, _ path: inout [DeviceData]) {
        path.append(navigateDetail)
    }
    
    func searchData(_ searchText: String) {
        if(searchText.isEmpty) {
            self.fetchAPI()
        }else{
            let realm = Realm.cache
            self.data = realm.objects(DeviceData.self).filter { data in
                data.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
