import MapKit
import Sharing
import SwiftUI

@MainActor
@Observable
final class VendorDetailsViewModel {

	// MARK: Properties

	let vendorId: Vendor.ID
	private(set) var vendor: Vendor?
	private(set) var flavours: [FlavourListItem]?

	var mapPosition: MapCameraPosition {
		.region(.init(center: vendor?.location.coordinate ?? .init(), latitudinalMeters: 200, longitudinalMeters: 200))
	}

	@ObservationIgnored
	@Shared(.fileStorage(.favourites))
	private var favourites: Set<Flavour.ID> = []

	@ObservationIgnored
	@Shared(.fileStorage(.tasted))
	private var tasted: Set<Flavour.ID> = []

	@ObservationIgnored
	@Shared(.fileStorage(.wishlist))
	private var wishlist: Set<Flavour.ID> = []

	// Dependencies
	private var vendorsRepository: VendorsRepository!
	private var flavoursRepository: FlavoursRepository!

	// MARK: Initialization

	init(vendorId: Vendor.ID) {
		self.vendorId = vendorId
	}

	// MARK: Public

	func setup(vendorsRepository: VendorsRepository, flavoursRepository: FlavoursRepository) {
		self.vendorsRepository = vendorsRepository
		self.flavoursRepository = flavoursRepository
	}

	func task() async {
		guard let vendor = vendorsRepository.fetch(id: vendorId) else { return }
		self.vendor = vendor
		flavours = flavoursRepository.fetch(ids: vendor.flavours)
			.map { FlavourListItem(id: $0.id, name: $0.name, description: $0.description, tags: $0.tags) }
	}

	var isFavourite: Bool { vendor?.flavours.contains(where: { favourites.contains($0) }) ?? false }
	var isTasted: Bool { vendor?.flavours.contains(where: { tasted.contains($0) }) ?? false }
	var isWishlist: Bool { vendor?.flavours.contains(where: { wishlist.contains($0) }) ?? false }
}

extension VendorDetailsViewModel {
	struct FlavourListItem: Identifiable {
		let id: Flavour.ID
		let name: String
		let description: [String]
		let tags: Set<Flavour.Tag>
	}
}