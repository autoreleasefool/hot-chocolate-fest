import CoreLocation
import Foundation

struct Vendor: Identifiable, Hashable {
	let name: String
	let location: Location
	let flavours: [Flavour]

	var id: String { name }
}

extension Vendor {
	struct Flavour: Identifiable, Hashable {
		let id: Int
		let name: String
		let description: String
		let availability: [DateInterval]
	}
}

extension Vendor {
	struct Location: Hashable {
		let latitude: Double
		let longitude: Double

		var coordinate: CLLocationCoordinate2D {
			CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		}
	}
}
