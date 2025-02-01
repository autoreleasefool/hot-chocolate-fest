import Foundation

actor ResourceLoader {
	func loadFlavours() async throws -> [Resources.Flavour] {
		let url = Bundle.main.url(forResource: "flavours-parsed", withExtension: "json")!
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode([Resources.Flavour].self, from: data)
	}

	func loadRegions() async throws -> [Resources.Region] {
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

		var id: HCF.Flavour.ID {
			.init(Int(name.prefix(4).dropFirst())!)
		}
	}

	struct Region: Decodable {
		let name: String
		let locations: [Location]
	}

	struct Location: Decodable {
		let id: String
		let name: String
		let lat: Double
		let lon: Double
	}
}
