import SwiftData

@Model
class TastedFlavour: Identifiable {
	@Attribute(.unique) var name: String
	var id: String { name }

	init(name: String) {
		self.name = name
	}
}
