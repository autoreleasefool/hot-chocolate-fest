import Sharing
import SwiftUI

@MainActor
@Observable
final class FlavourDetailsViewModel {
	let flavourId: Flavour.ID
    var flavour: Flavour?

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

    private var repository: FlavoursRepository!

	// MARK: Initialization

	init(flavourId: Flavour.ID) {
		self.flavourId = flavourId
	}

	// MARK: Public

    func setup(repository: FlavoursRepository) {
        self.repository = repository
    }

    func task() async {
        flavour = repository.fetch(id: flavourId)
    }

    var isFavourite: Bool { favourites.contains(flavourId) }
    var isTasted: Bool { tasted.contains(flavourId) }
    var isWishlist: Bool { wishlist.contains(flavourId) }
    var description: [String] { flavour?.description ?? [] }
    var tags: [Flavour.Tag] { Flavour.Tag.allCases.filter { flavour?.tags.contains($0) ?? false } }

    func handleAction(_ action: FlavourDetailsView.Action) async {
        switch action {
        case .didToggleFavourite:
            await toggleFavourite()
        case .didToggleTasted:
            await toggleTasted()
        case .didToggleWishlist:
            await toggleWishlist()
        }
    }

    // MARK: Private

    private func toggleFavourite() async {
        $favourites.withLock { $0.toggle(flavourId) }
    }

    private func toggleTasted() async {
        $tasted.withLock { $0.toggle(flavourId) }
    }

    private func toggleWishlist() async {
        $wishlist.withLock { $0.toggle(flavourId) }
    }
}
