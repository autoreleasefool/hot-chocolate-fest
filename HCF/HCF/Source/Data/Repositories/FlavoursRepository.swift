import Foundation
import Sharing
import RegexBuilder

@MainActor
final class FlavoursRepository: ObservableObject {
	init() {}

	private var flavoursList: [Flavour.ID] = []
	private var flavours: [Flavour.ID: Flavour]?

	// MARK: Public

	func fetch(id: Flavour.ID) -> Flavour? {
		flavours?[id]
	}

	func fetch() async throws -> [Flavour] {
		if flavours == nil {
			let flavours = try await loadFlavours()
			self.flavoursList = flavours.map(\.id)
			self.flavours = Dictionary(uniqueKeysWithValues: flavours.map { ($0.id, $0) })
		}

		return self.flavoursList.compactMap { flavours?[$0] }
	}

	// MARK: Private

	private nonisolated func loadFlavours() async throws -> [Flavour] {
		let resourceLoader = ResourceLoader()

		let flavours = try await resourceLoader.loadFlavours()

		return flavours.map {
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
	}

	private nonisolated func retrieveAvailability(fromText text: String) -> [DateInterval] {
		let availabilityPattern = Regex {
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
}
