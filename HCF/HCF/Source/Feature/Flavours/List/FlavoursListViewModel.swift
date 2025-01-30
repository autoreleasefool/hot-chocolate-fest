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

	private(set) var query: String = ""
	private(set) var filter: Filter = .all
	private(set) var tags: Set<Flavour.Tag> = []

	private(set) var flavours: [FlavourListItem] = []

	// Dependencies
	private var repository: FlavoursRepository!

	// MARK: Public

	func setup(repository: FlavoursRepository) {
		self.repository = repository
	}

	func task() async {
		await refreshFlavours()
	}

	func handleListAction(_ action: FlavoursListView.Action) async {
		switch action {
		case let .didToggleTag(tag): await toggleTag(tag)
		case let .didChangeQuery(query): await changeQuery(query)
		case let .didChangeFilter(filter): await changeFilter(filter)
		}
	}

	func handleListRowAction(_ action: FlavourListItemRow.Action) async {
		switch action {
		case let .didToggleFavourite(id): await toggleFavourite(id)
		case let .didToggleTasted(id): await toggleTaste(id)
		case let .didToggleWishlist(id): await toggleWishlist(id)
		}
	}

	func isTagEnabled(_ tag: Flavour.Tag) -> Bool {
		tags.contains(tag)
	}

	@MainActor
	func getFlavour(id: Flavour.ID) -> Flavour? {
		repository.fetch(id: id)
	}

	// MARK: Private

	private func changeQuery(_ query: String) async {
		self.query = query
		await refreshFlavours()
	}

	private func changeFilter(_ filter: Filter) async {
		self.filter = filter
		await refreshFlavours()
	}

	private func toggleFavourite(_ id: Flavour.ID) async {
		$favourites.withLock { $0.toggle(id) }
		await refreshFlavours()
	}

	private func toggleTaste(_ id: Flavour.ID) async {
		$tasted.withLock { $0.toggle(id) }
		await refreshFlavours()
	}

	private func toggleWishlist(_ id: Flavour.ID) async {
		$wishlist.withLock { $0.toggle(id) }
		await refreshFlavours()
	}

	private func toggleTag(_ tag: Flavour.Tag) async {
		tags.toggle(tag)
		await refreshFlavours()
	}

	private func refreshFlavours() async {
		do {
			let flavours = try await repository.fetch()
			self.flavours = flavours
				.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) || String($0.id).contains(query) }
				.filter { filter != .favourites || isFavourite($0) }
				.filter { filter != .tasted || isTasted($0) || isFavourite($0) }
				.filter { filter != .wishlist || isWishlist($0) }
				.filter { tags.isEmpty || !tags.isDisjoint(with: $0.tags) }
				.map {
					FlavourListItem(
						id: $0.id,
						name: $0.name,
						isFavourite: isFavourite($0),
						isTasted: isTasted($0),
						isWishlist: isWishlist($0),
						tags: $0.tags
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
		let id: Flavour.ID
		let name: String
		let isFavourite: Bool
		let isTasted: Bool
		let isWishlist: Bool
		let tags: Set<Flavour.Tag>
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
