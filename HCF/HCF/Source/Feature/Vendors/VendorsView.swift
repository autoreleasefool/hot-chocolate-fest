import SwiftUI

struct VendorsView: View {
	@State private var query: String = ""
	@State private var vendors: [Vendor]?
	@State private var display: Display = .map

	var body: some View {
		content
			.task { await refreshVendors() }
			.task(id: query) {
				do {
					try await Task.sleep(for: .milliseconds(300))
					await refreshVendors()
				} catch {}
			}
			.navigationTitle("Locations")
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $query)
			.navigationDestination(for: Vendor.self) {
				VendorDetailsView(vendor: $0)
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						display.toggle()
					} label: {
						Image(systemName: display == .map ? "list.bullet" : "map")
					}
				}
			}
	}

	@ViewBuilder
	private var content: some View {
		if let vendors {
			switch display {
			case .map:
				VendorsMapView(vendors: vendors)
			case .list:
				VendorsListView(vendors: vendors)
			}
		} else {
			ProgressView()
		}
	}

	private func refreshVendors() async {
		self.vendors = (try? await VendorRepository.shared.loadVendors(matching: query)) ?? []
	}
}

extension VendorsView {
	enum Display {
		case map
		case list

		mutating func toggle() {
			self = switch self {
			case .list: .map
			case .map: .list
			}
		}
	}
}
