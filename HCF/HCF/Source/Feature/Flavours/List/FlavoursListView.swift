import SwiftData
import SwiftUI

struct FlavoursListView: View {
	@Environment(\.modelContext) private var context

	@State private var query: String = ""
	@State private var flavours: [Flavour] = []
	@State private var filter: Filter = .all

	@Query var favourites: [FavouriteFlavour]
	@State var favouriteIds: Set<Int> = []

	@Query var tasted: [TastedFlavour]
	@State var tastedIds: Set<Int> = []

	var body: some View {
		List {
			ForEach(flavours) { flavour in
				FlavourView(
					flavour: flavour,
					isFavourite: favouriteIds.contains(flavour.id),
					isTasted: tastedIds.contains(flavour.id),
					onToggleFavourite: { await toggleFavourite(flavour) },
					onToggleTaste: { await toggleTaste(flavour) }
				)
			}
		}
		.task { await refreshFlavours() }
		.task(id: query) {
			do {
				try await Task.sleep(for: .milliseconds(300))
				await refreshFlavours()
			} catch {}
		}
		.onChange(of: favourites, initial: true) { favouriteIds = Set(favourites.map(\.flavourId)) }
		.onChange(of: tasted, initial: true) { tastedIds = Set(tasted.map(\.flavourId)) }
		.onChange(of: filter) { Task { await refreshFlavours() } }
		.navigationTitle("Flavours")
		.searchable(text: $query)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Menu("Filter") {
					ForEach(Filter.allCases) { filter in
						Button {
							self.filter = filter
						} label: {
							if self.filter == filter {
								Label(filter.title, systemImage: "checkmark")
							} else {
								Text(filter.title)
							}
						}
					}
				}
			}
		}
		.navigationDestination(for: Flavour.self) { flavour in
			FlavourDetailsView(flavour: flavour)
		}
	}

	private func toggleFavourite(_ flavour: Flavour) async {
		withAnimation {
			if let favourite = favourites.first(where: { $0.flavourId == flavour.id }) {
				context.delete(favourite)
			} else {
				let favourite = FavouriteFlavour(flavourId: flavour.id)
				context.insert(favourite)
			}
		}

		try? context.save()
	}

	private func toggleTaste(_ flavour: Flavour) async {
		withAnimation {
			if let tasted = tasted.first(where: { $0.flavourId == flavour.id }) {
				context.delete(tasted)
			} else {
				let tasted = TastedFlavour(flavourId: flavour.id)
				context.insert(tasted)
			}
		}

		try? context.save()
	}

	private func refreshFlavours() async {
		self.flavours = ((try? await FlavourRepository.shared.loadFlavours(matching: query)) ?? [])
			.filter { flavour in filter != .favourites || favouriteIds.contains(flavour.id) }
			.filter { flavour in filter != .tasted || tastedIds.contains(flavour.id) || favouriteIds.contains(flavour.id) }
	}
}

extension FlavoursListView {
	enum Filter: Identifiable, Hashable, CaseIterable {
		case all
		case favourites
		case tasted

		var id: Self { self }

		var title: String {
			switch self {
			case .all: return "All"
			case .favourites: return "Favourites"
			case .tasted: return "Tasted"
			}
		}
	}
}
