import SwiftUI

struct ContentView: View {
  
    @StateObject private var viewModel = ContentViewModel()
    @State private var path: [DeviceData] = []

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
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceData.self) { computer in
                DetailView(device: computer)
            }
            .onAppear {
                if viewModel.data?.isEmpty ?? true {
                    viewModel.fetchAPI()
                }
            }
        }
    }
}
