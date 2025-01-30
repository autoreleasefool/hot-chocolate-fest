import Sharing
import SwiftUI

@Observable
final class FlavoursListViewModel {

	// MARK: Properties

	@ObservationIgnored
	@Shared(.fileStorage(.favourites))
	private var favourites: Set<Flavour.ID> = []

	@ObservationIgnored
	@Shared(.fileStorage(.tasted))
	private var tasted: Set<Flavour.ID> = []

	@ObservationIgnored
	@Shared(.fileStorage(.wishlist))
	private var wishlist: Set<Flavour.ID> = []

	var query: String = "" {
		didSet {
			Task { await refreshFlavours() }
		}
	}

	var filter: Filter = .all {
		didSet {
			Task { await refreshFlavours() }
		}
	}

	var flavours: [FlavourListItem] = []

	// Dependencies
	private var repository: FlavoursRepository!

	// MARK: Public

	func setup(repository: FlavoursRepository) {
		self.repository = repository
	}

	func task() async {
		await refreshFlavours()
	}

	func refresh() async {
		await refreshFlavours()
	}

	func toggleFavourite(_ flavour: FlavourListItem) async {
		$favourites.withLock { $0.toggle(flavour.id) }
		await refreshFlavours()
	}

	func toggleTaste(_ flavour: FlavourListItem) async {
		$tasted.withLock { $0.toggle(flavour.id) }
		await refreshFlavours()
	}

	func toggleWishlist(_ flavour: FlavourListItem) async {
		$wishlist.withLock { $0.toggle(flavour.id) }
		await refreshFlavours()
	}

	// MARK: Private

	private func refreshFlavours() async {
		do {
			let flavours = try await repository.fetch()
			self.flavours = flavours
				.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) || String($0.id).contains(query) }
				.filter { filter != .favourites || isFavourite($0) }
				.filter { filter != .tasted || isTasted($0) || isFavourite($0) }
				.filter { filter != .wishlist || isWishlist($0) }
				.map {
					FlavourListItem(
						id: $0.id,
						name: $0.name,
						isFavourite: isFavourite($0),
						isTasted: isTasted($0),
						isWishlist: isWishlist($0)
					)
				}
		} catch {
			print(error)
		}
	}

	private func isFavourite(_ flavour: Flavour) -> Bool {
		favourites.contains(flavour.id)
	}

	private func isTasted(_ flavour: Flavour) -> Bool {
		tasted.contains(flavour.id)
	}

	private func isWishlist(_ flavour: Flavour) -> Bool {
		wishlist.contains(flavour.id)
	}
}

// MARK: FlavourListItem

extension FlavoursListViewModel {
	struct FlavourListItem: Identifiable {
		let id: Int
		let name: String
		let isFavourite: Bool
		let isTasted: Bool
		let isWishlist: Bool
	}
}

// MARK: Filter

extension FlavoursListViewModel {
	enum Filter: Identifiable, Hashable, CaseIterable {
		case all
		case favourites
		case tasted
		case wishlist

		var id: Self { self }
	}
}
