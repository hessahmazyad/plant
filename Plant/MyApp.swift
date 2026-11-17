import SwiftUI
import SwiftData

@main struct MyApp: App {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false

    // قاعدة البيانات (تنعمل مرة وحدة)
    let container: ModelContainer

    init() {
        container = try! ModelContainer(for: Plant.self)
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            if hasSeenWelcome {
                PlantListView(context: container.mainContext)
            } else {
                ContentView()
            }
        }
    }
}
