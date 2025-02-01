import SwiftUI

@main
struct HCFApp: App {

	@StateObject private var flavoursRepository = FlavoursRepository()
	@StateObject private var vendorsRepository = VendorsRepository()
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(flavoursRepository)
				.environmentObject(vendorsRepository)
		}
	}
}
