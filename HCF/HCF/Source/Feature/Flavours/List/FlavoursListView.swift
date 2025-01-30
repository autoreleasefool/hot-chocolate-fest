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
				FlavourListItemRow(flavour: flavour) { action in
					await viewModel.handleListRowAction(action)
				}
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
				Menu(viewModel.filter.menuTitle) {
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
		.navigationDestination(for: Flavour.ID.self) { flavourId in
			if let flavour = viewModel.getFlavour(id: flavourId) {
				FlavourDetailsView(flavour: flavour)
			} else {
				EmptyView()
			}
		}
	}
}

extension FlavoursListViewModel.Filter {
	var title: String {
		switch self {
		case .all: "All"
		case .favourites: "Favourites"
		case .tasted: "Tasted"
		case .wishlist: "Wishlist"
		}
	}

	var menuTitle: String {
		switch self {
		case .all: "Filter"
		case .favourites: "Favourites"
		case .tasted: "Tasted"
		case .wishlist: "Wishlist"
		}
	}
}
