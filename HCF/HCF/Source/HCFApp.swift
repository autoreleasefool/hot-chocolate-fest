import SwiftUI

@main
struct HCFApp: App {

	@StateObject private var flavoursRepository = FlavoursRepository()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.modelContainer(for: [
					FavouriteFlavour.self,
					TastedFlavour.self
				])
				.environmentObject(flavoursRepository)
		}
	}
}
