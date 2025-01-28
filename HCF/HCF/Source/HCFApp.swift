import SwiftUI

@main
struct HCFApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.modelContainer(for: [
					FavouriteFlavour.self,
					TastedFlavour.self
				])
		}
	}
}
