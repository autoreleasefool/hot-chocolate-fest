import SwiftData
import SwiftUI

struct FlavourDetailsView: View {
	@Environment(\.modelContext) private var context

	let flavour: Flavour

	@Query private var favourites: [FavouriteFlavour]
	private var favourite: FavouriteFlavour? { favourites.first }
	private var isFavourite: Bool { favourite != nil }
	@Query private var tasteds: [TastedFlavour]
	private var tasted: TastedFlavour? { tasteds.first }
	private var hasTasted: Bool { tasted != nil }

	init(flavour: Flavour) {
		self.flavour = flavour

		let id = flavour.id
		_favourites = Query(filter: #Predicate<FavouriteFlavour> { f in
			f.flavourId == id
		})
		_tasteds = Query(filter: #Predicate<TastedFlavour> { f in
			f.flavourId == id
		})
	}

	var body: some View {
		List {
			Text(flavour.description)
		}
		.navigationTitle(flavour.name)
		.toolbar {
			ToolbarItem {
				Button {
					Task {
						await toggleFavourite()
					}
				} label: {
					Image(systemName: "star")
						.symbolVariant(isFavourite ? .fill : .none)
				}
			}

			ToolbarItem {
				Button {
					Task {
						await toggleTasted()
					}
				} label: {
					Image(systemName: "cup.and.saucer")
						.symbolVariant(hasTasted ? .fill : .none)
				}
			}
		}
	}

	private func toggleFavourite() async {
		if let favourite {
			context.delete(favourite)
		} else {
			let favourite = FavouriteFlavour(flavourId: flavour.id)
			context.insert(favourite)
		}

		try? context.save()
	}

	private func toggleTasted() async {
		if let tasted {
			context.delete(tasted)
		} else {
			let tasted = TastedFlavour(flavourId: flavour.id)
			context.insert(tasted)
		}

		try? context.save()
	}
}
