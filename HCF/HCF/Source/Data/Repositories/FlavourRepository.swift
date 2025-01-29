import Foundation
import RegexBuilder

actor FlavourRepository {
	static let shared = FlavourRepository()

	private var flavours: [Flavour]?

	func loadFlavours(matching query: String = "") async throws -> [Flavour] {
		if let flavours {
			return filter(flavours, with: query)
		}

		let flavourResources = try await ResourceLoader.shared.loadFlavours()
//		let regionResources = try await ResourceLoader.shared.loadRegions()

		let flavours = flavourResources.map {
			Flavour(
				id: Int($0.name.prefix(4).dropFirst())!,
				name: $0.name.dropFirst(6).trimmingCharacters(in: .whitespaces),
				description: String($0.description.drop(while: { !$0.isNewline }).dropFirst()),
				availability: retrieveAvailability(fromText: $0.description),
				vendor: Flavour.Vendor(
					name: $0.vendor_name,
					location: .init(latitude: 0.0, longitude: 0.0),
					website: $0.vendor_url
				)
			)
		}

		self.flavours = flavours
		return filter(flavours, with: query)
	}

	private func filter(_ flavours: [Flavour], with query: String) -> [Flavour] {
		guard !query.isEmpty else {
			return flavours
		}

		return flavours.filter { flavour in
			flavour.name.localizedCaseInsensitiveContains(query) || String(flavour.id).contains(query)
		}
	}

	private func retrieveAvailability(fromText text: String) -> [DateInterval] {
		let matches = text.matches(of: availabilityPattern)
		guard !matches.isEmpty else {
			return [DateInterval(start: Constants.Dates.startDate, end: Constants.Dates.endDate)]
		}

		let calendar = Calendar(identifier: .gregorian)

		return matches.compactMap { match in
			let startDate = extractDate(from: match.output.1, format: "MMMM dd") ??
				Constants.Dates.startDate
			let startMonth = calendar.dateComponents([.month], from: startDate).month!

			let endDate = extractDate(from: match.output.2, format: "MMMM dd") ??
				extractDate(from: "\(startMonth) \(match.output.2)", format: "M dd") ??
				Constants.Dates.endDate

			return DateInterval(start: startDate, end: endDate)
		}
	}

	private let availabilityPattern = Regex {
		Capture {
			ChoiceOf {
				"January"
				"February"
			}

			Repeat(1...2) {
				One(.digit)
			}
		}

		Optionally(" ")
		"-"

		Capture {
			Optionally {
				ChoiceOf {
					"January"
					"February"
				}
				" "
			}

			Repeat(1...2) {
				One(.digit)
			}
		}
	}
}

//available (february|january) \d{1,2} ?- (february |january )?\d{1,2}
