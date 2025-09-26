//
//  ContentView.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ContentViewModel()
    @State private var path: [DeviceData] = [] // Navigation path

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if let computers = viewModel.data, !computers.isEmpty {
                                    DevicesList(devices: computers) { selectedComputer in
                                        path.append(selectedComputer)
                                    }
                } else {
                    ProgressView("Loading...")
                    
                }
            }
            .onChange(of: viewModel.navigateDetail, {
                let navigate = viewModel.navigateDetail
                    path.append(navigate!)
                })
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceData.self) { computers in
                DetailView(device: computers)
            }
            .onAppear {
                if viewModel.data?.isEmpty ?? true {
                                    viewModel.fetchAPI()
                                }
                    .navigationTitle("Devices")
                                .navigationDestination(for: DeviceData.self) { computer in
                                    DetailView(device: computer)
                                }
                }
            }
        }
    }
}
