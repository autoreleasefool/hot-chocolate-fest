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
	enum Tag: Hashable, CaseIterable, Identifiable {
		case glutenFree
		case nuts
		case coconut
		case sesame
		case alcohol
		case dairyFreeOrVegan

		var id: Self { self }

		var title: String {
			switch self {
			case .glutenFree: "Gluten Free"
			case .nuts: "Contains Nuts"
			case .coconut: "Contains Coconut"
			case .sesame: "Contains Sesame"
			case .alcohol: "Contains Alcohol"
			case .dairyFreeOrVegan: "Dairy Free / Vegan"
			}
		}
	}
}

extension Flavour {
	enum Availability: Hashable {
		case availableNow
		case availableSoon
		case expired
	}
}
