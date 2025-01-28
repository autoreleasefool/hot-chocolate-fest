import SwiftData

@Model
class TastedFlavour: Identifiable {
	@Attribute(.unique) var flavourId: Int

	init(flavourId: Int) {
		self.flavourId = flavourId
	}
}
