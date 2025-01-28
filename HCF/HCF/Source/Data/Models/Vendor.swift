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
		let name: String
		let description: String
		let startDate: Date
		let endDate: Date

		var id: String { name }
	}
}
