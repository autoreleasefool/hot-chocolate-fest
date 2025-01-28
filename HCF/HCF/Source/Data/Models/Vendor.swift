import CoreLocation
import Foundation

struct Vendor: Identifiable {
	let name: String
	let location: CLLocationCoordinate2D
	let flavours: [Flavour]

	var id: String { name }
}

extension Vendor {
	struct Flavour: Identifiable {
		let id: Int
		let name: String
		let description: String
		let availability: [DateInterval]
	}
}
