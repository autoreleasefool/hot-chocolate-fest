import SwiftUI
import SwiftData

struct FlavourView: View {
	let name: String
	let isFavourite: Bool

	var body: some View {
		HStack {
			Image(systemName: "star")
				.symbolVariant(isFavourite ? .fill : .none)

			Text(name)
		}
	}
}
