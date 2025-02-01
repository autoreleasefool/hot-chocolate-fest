import Foundation
import Sharing

@MainActor
final class VendorsRepository: ObservableObject {
	init() {}

	private var vendorsList: [Vendor.ID] = []
	private var vendors: [Vendor.ID: Vendor]?

	// MARK: Public

	func fetch(id: Vendor.ID) -> Vendor? {
		vendors?[id]
	}

	func fetch() async throws -> [Vendor] {
		if vendors == nil {
			let vendors = try await loadVendors()
			self.vendorsList = vendors.map(\.id)
			self.vendors = Dictionary(uniqueKeysWithValues: vendors.map { ($0.id, $0) })
		}

		return self.vendorsList.compactMap { vendors?[$0] }
	}
	
	// MARK: Private

	private nonisolated func loadVendors() async throws -> [Vendor] {
		let resourceLoader = ResourceLoader()

		let regions = try await resourceLoader.loadRegions()
		let flavours = try await resourceLoader.loadFlavours()

		return regions.flatMap { region in
			return region.locations.map { location in
				Vendor(
					id: Vendor.ID(location.id),
					name: location.name, 
					location: Vendor.Location(latitude: location.lat, longitude: location.lon),
					url: URL(string: "google.com")!,
					flavours: flavours.filter {
						$0.vendor_name.localizedLowercase.prefix(6) == location.name.localizedLowercase.prefix(6)
					}.map(\.id)
				)
			}
		}
	}
}