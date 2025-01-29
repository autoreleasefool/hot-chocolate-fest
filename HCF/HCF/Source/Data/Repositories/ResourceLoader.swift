import Foundation

actor ResourceLoader {
	private var flavours: [Resources.Flavour]?
	private var regions: [Resources.Region]?

	static let shared: ResourceLoader = .init()

	func loadFlavours() async throws -> [Resources.Flavour] {
		if let flavours {
			return flavours
		}

		let url = Bundle.main.url(forResource: "flavours-parsed", withExtension: "json")!
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode([Resources.Flavour].self, from: data)
	}

	func loadRegions() async throws -> [Resources.Region] {
		if let regions {
			return regions
		}

		let url = Bundle.main.url(forResource: "map-parsed", withExtension: "json")!
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode([Resources.Region].self, from: data)
	}

}

enum Resources {
	struct Flavour: Decodable {
		let name: String
		let description: String
		let vendor_name: String
		let vendor_url: URL
	}

	struct Region: Decodable {
		let name: String
		let locations: [Location]
	}

	struct Location: Decodable {
		let name: String
		let lat: Double
		let lon: Double
	}
}
