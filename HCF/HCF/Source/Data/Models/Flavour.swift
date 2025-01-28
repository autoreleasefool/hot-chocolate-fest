import CoreLocation
import Foundation

struct Flavour: Identifiable {
	let id: Int
	let name: String
	let description: String
	let availability: [DateInterval]
	let vendor: Vendor
}

extension Flavour {
	struct Vendor {
		let name: String
		let location: CLLocationCoordinate2D
		let website: URL
	}
}
