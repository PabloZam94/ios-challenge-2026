import SwiftUI

struct ContentView: View {
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies = .live) {
        self.dependencies = dependencies
    }

    var body: some View {
        TabView {
            // MARK: - Tab 1: Cat List
            NavigationStack {
                BreedListView(viewModel: BreedListViewModel(service: dependencies.breedService))
            }
            .tabItem {
                Label("Cats", systemImage: "cat")
            }

            // MARK: - Tab 2: Add Cat
            NavigationStack {
                AddCatStepperView(viewModel: AddCatViewModel(store: dependencies.catStore))
            }
            .tabItem {
                Label("Add Cat", systemImage: "plus.circle")
            }
        }
        .tint(AppTheme.Colors.primary)
    }
}

#Preview {
    ContentView()
}
