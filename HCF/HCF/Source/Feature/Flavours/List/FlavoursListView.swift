import Sharing
import SwiftData
import SwiftUI

struct FlavoursListView: View {
	@EnvironmentObject private var flavoursRepository: FlavoursRepository

	@State private var viewModel = FlavoursListViewModel()
	@State private var query: String = ""

	var body: some View {
		List {
			ForEach(viewModel.flavours) { flavour in
				FlavourView(
					flavour: flavoursRepository.fetch(id: flavour.id)!,
					isFavourite: flavour.isFavourite,
					isTasted: flavour.isTasted,
					isWishlist: flavour.isWishlist,
					onToggleFavourite: { await viewModel.toggleFavourite(flavour) },
					onToggleTaste: { await viewModel.toggleTaste(flavour) },
					onToggleWishlist: { await viewModel.toggleWishlist(flavour) }
				)
			}
		}
		.task {
			viewModel.setup(repository: flavoursRepository)
			await viewModel.task()
		}
		.task(id: query) {
			do {
				try await Task.sleep(for: .milliseconds(300))
				viewModel.query = query
			} catch {}
		}
		.navigationTitle("Flavours")
		.searchable(text: $query)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Menu("Filter") {
					ForEach(FlavoursListViewModel.Filter.allCases) { filter in
						Button {
							viewModel.filter = filter
						} label: {
							if viewModel.filter == filter {
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
}

extension FlavoursListViewModel.Filter {
	var title: String {
		switch self {
		case .all: return "All"
		case .favourites: return "Favourites"
		case .tasted: return "Tasted"
		case .wishlist: return "Wishlist"
		}
	}
}
