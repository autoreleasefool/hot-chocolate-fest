import CoreLocation
import Foundation
import Tagged

struct Flavour: Identifiable, Hashable {
	typealias ID = Tagged<Flavour, Int>
	
	let id: ID
	let name: String
	let description: [String]
	let dates: [DateInterval]
	let tags: Set<Tag>
	let vendor: Vendor.ID

	func availability(for date: Date = .now) -> Availability {
		if dates.contains(where: { $0.contains(date) }) {
			.availableNow
		} else if dates.contains(where: { date < $0.start }) {
			.availableSoon
		} else {
			.expired
		}
	}
}

extension Flavour {
	enum Tag: Hashable {
		case glutenFree
		case nuts
		case coconut
		case sesame
		case alcohol
		case dairyFreeOrVegan
	}
}

extension Flavour {
	enum Availability: Hashable {
		case availableNow
		case availableSoon
		case expired
	}
}
