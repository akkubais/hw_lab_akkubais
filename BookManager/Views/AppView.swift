import SwiftUI

struct AppView: View {
    @StateObject private var library = Library()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
                .tag(0)

            NewBookView()
                .tabItem {
                    Label("New Book", systemImage: "rectangle.stack.badge.plus")
                }
                .tag(1)

            ChartsView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.xaxis")
                }
                .tag(2)
        }
        .tint(.indigo)
        .environmentObject(library)
        .accessibilityAction(named: "Show Library") {
            selectedTab = 0
        }
        .accessibilityAction(named: "Show New Book") {
            selectedTab = 1
        }
        .accessibilityAction(named: "Show Charts") {
            selectedTab = 2
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
