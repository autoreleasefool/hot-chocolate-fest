import Foundation

actor VendorRepository {
	static let shared = VendorRepository()

	private var vendors: [Vendor]?

	func loadVendors(matching query: String = "") async throws -> [Vendor] {
		if let vendors {
			return filter(vendors, with: query)
		}

		let resourceLoader = ResourceLoader()
		let regionResources = try await resourceLoader.loadRegions()
		let flavourResources = try await resourceLoader.loadFlavours()

		let vendors = regionResources.flatMap { region in
			region.locations.map {
				Vendor(
					name: $0.name,
					location: .init(latitude: $0.lat, longitude: $0.lon),
					url: URL(string: "google.com")!,
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
		}
	}
}
