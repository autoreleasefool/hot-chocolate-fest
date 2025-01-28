import SwiftData

@Model
class FavouriteFlavour: Identifiable {
	@Attribute(.unique) var flavourId: Int

	init(flavourId: Int) {
		self.flavourId = flavourId
	}
}
