//
//  ContentView.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State private var path: [DeviceData] = [] // Navigation path
    @State var searchText: String = ""

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                //not going inside condition, condition not satisfied maybe ?,
                if let computers = viewModel.data, !computers.isEmpty {
                    if(viewModel.isFromCache) {
                        Text("Fetched data from cache !")
                            .font(.headline)
                            .padding()
                    }
                    DevicesList(devices: computers) { selectedComputer in
                        viewModel.navigateToDetail(navigateDetail: selectedComputer, &self.path)
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceData.self) { computer in
                DetailView(device: computer)
            }
            .searchable(text: self.$searchText)
            .onChange(of: self.searchText) { oldValue, newValue in
                print("search for: \(newValue)")
                viewModel.searchData(newValue)
            }
        }
    }
}
