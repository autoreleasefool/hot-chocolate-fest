import CoreLocation
import Foundation

struct Flavour: Identifiable {
	let name: String
	let description: String
	let startDate: Date
	let endDate: Date
	let vendor: Vendor

	var id: String { name }
}

extension Flavour {
	struct Vendor {
		let name: String
		let location: CLLocationCoordinate2D
		let website: URL
	}
}
