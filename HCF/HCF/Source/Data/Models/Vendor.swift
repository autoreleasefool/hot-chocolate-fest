import CoreLocation
import Foundation
import Tagged

struct Vendor: Identifiable, Hashable {
	typealias ID = Tagged<Vendor, String>

	let id: ID
	let name: String
	let location: Location
	let url: URL
	let flavours: [Flavour.ID]
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
