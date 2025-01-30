import SwiftUI
import SwiftData

struct FlavourListItemRow: View {
	let flavour: FlavoursListViewModel.FlavourListItem
	let onAction: (Action) async -> Void

	var body: some View {
		NavigationLink(value: flavour.id) {
			HStack {
				Image(systemName: "star")
					.symbolVariant(flavour.isFavourite ? .fill : .none)

				Text(flavour.name)
			}
		}
		.swipeActions(edge: .trailing) {
			Button {
				Task {
					await onAction(.didToggleFavourite(flavour.id))
				}
			} label: {
				if flavour.isFavourite {
					Label("Unfavourite", systemImage: "star.slash")
				} else {
					Label("Favourite", systemImage: "star")
				}
			}
			.tint(.yellow)

			Button {
				Task {
					await onAction(.didToggleTasted(flavour.id))
				}
			} label: {
				if flavour.isTasted {
					Label("Remove", systemImage: "cup.and.saucer")
				} else {
					Label("Taste", systemImage: "cup.and.heat.waves")
				}
			}
			.tint(.blue)

			Button {
				Task {
					await onAction(.didToggleWishlist(flavour.id))
				}
			} label: {
				if flavour.isWishlist {
					Label("Remove", systemImage: "heart.slash")
				} else {
					Label("Taste", systemImage: "heart")
				}
			}
			.tint(.red)
		}
	}
}

extension FlavourListItemRow {
	enum Action {
		case didToggleFavourite(Flavour.ID)
		case didToggleTasted(Flavour.ID)
		case didToggleWishlist(Flavour.ID)
	}
}
