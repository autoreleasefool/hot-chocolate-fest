import SwiftUI

struct HCTabView: View {
	@State private var selection: AppTab = .flavours

	var body: some View {
		TabView(selection: $selection) {
			Tab("Flavours", systemImage: "cup.and.heat.waves", value: .flavours) {
				FlavoursTabView()
			}

			Tab("Locations", systemImage: "mappin.and.ellipse.circle", value: .vendors) {
				VendorsTabView()
			}
		}
	}
}
