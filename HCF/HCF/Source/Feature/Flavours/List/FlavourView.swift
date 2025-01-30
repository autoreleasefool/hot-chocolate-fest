import SwiftUI
import SwiftData

struct FlavourView: View {
	let flavour: Flavour

	let isFavourite: Bool
	let isTasted: Bool
	let isWishlist: Bool
	let onToggleFavourite: () async -> Void
	let onToggleTaste: () async -> Void
	let onToggleWishlist: () async -> Void

	var body: some View {
		NavigationLink(value: flavour) {
			HStack {
				Image(systemName: "star")
					.symbolVariant(isFavourite ? .fill : .none)
				
				Text(flavour.name)
			}
		}
		.swipeActions(edge: .trailing) {
			Button {
				Task {
					await onToggleFavourite()
				}
			} label: {
				if isFavourite {
					Label("Unfavourite", systemImage: "star.slash")
				} else {
					Label("Favourite", systemImage: "star")
				}
			}
			.tint(.yellow)

			Button {
				Task {
					await onToggleTaste()
				}
			} label: {
				if isTasted {
					Label("Remove", systemImage: "cup.and.saucer")
				} else {
					Label("Taste", systemImage: "cup.and.heat.waves")
				}
			}
			.tint(.blue)

			Button {
				Task {
					await onToggleWishlist()
				}
			} label: {
				if isWishlist {
					Label("Remove", systemImage: "heart.slash")
				} else {
					Label("Taste", systemImage: "heart")
				}
			}
			.tint(.red)
		}
	}
}
