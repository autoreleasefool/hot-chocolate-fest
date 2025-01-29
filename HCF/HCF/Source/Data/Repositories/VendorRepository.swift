import Foundation

actor VendorRepository {
	static let shared = VendorRepository()

	private var vendors: [Vendor]?

	func loadVendors(matching query: String = "") async throws -> [Vendor] {
		if let vendors {
			return filter(vendors, with: query)
		}

		let regionResources = try await ResourceLoader.shared.loadRegions()
		let flavourResources = try await ResourceLoader.shared.loadFlavours()

		let vendors = regionResources.flatMap { region in
			region.locations.map {
				Vendor(
					name: $0.name,
					location: .init(latitude: $0.lat, longitude: $0.lon),
					flavours: []
				)
			}
		}

		self.vendors = vendors
		return filter(vendors, with: query)
	}

	private func filter(_ vendors: [Vendor], with query: String) -> [Vendor] {
		guard !query.isEmpty else { return vendors }

		return vendors.filter { vendor in
			vendor.name.localizedCaseInsensitiveContains(query)
			|| vendor.flavours.contains { flavour in
				flavour.name.localizedCaseInsensitiveContains(query)
			}
		}
	}
}
