import Flow
import Sharing
import SwiftData
import SwiftUI


struct FlavoursListView: View {
	@EnvironmentObject private var flavoursRepository: FlavoursRepository

	@State private var viewModel = FlavoursListViewModel()
	@State private var query: String = ""

	var body: some View {
		List {
			Section {
				HFlow {
					ForEach(Flavour.Tag.allCases) { tag in
						badge(for: tag, isEnabled: viewModel.isTagEnabled(tag))
					}
				}
			}
			.listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
			.listRowBackground(Color.clear)

			Section {
				ForEach(viewModel.flavours) { flavour in
					FlavourListItemRow(flavour: flavour) { action in
						await viewModel.handleListRowAction(action)
					}
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
				await viewModel.handleListAction(.didChangeQuery(query))
			} catch {}
		}
		.navigationTitle("Flavours")
		.searchable(text: $query)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				filterMenu
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

	@ViewBuilder
	private var filterMenu: some View {
		Menu(viewModel.filter.menuTitle) {
			ForEach(FlavoursListViewModel.Filter.allCases) { filter in
				Button {
					Task {
						await viewModel.handleListAction(.didChangeFilter(filter))
					}
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

	@ViewBuilder
	private func badge(for tag: Flavour.Tag, isEnabled: Bool) -> some View {
		Button {
			Task {
				await viewModel.handleListAction(.didToggleTag(tag))
			}
		} label: {
			Text(tag.title)
				.font(.subheadline)
				.padding(6)
				.foregroundStyle(tag.foreground(isEnabled: isEnabled))
				.background {
					Capsule()
						.fill(tag.background(isEnabled: isEnabled))
						.stroke((tag.foreground(isEnabled: isEnabled)))
				}
		}
		.buttonStyle(.plain)
	}
}

extension FlavoursListView {
	enum Action {
		case didToggleTag(Flavour.Tag)
		case didChangeQuery(String)
		case didChangeFilter(FlavoursListViewModel.Filter)
	}
}

extension Flavour.Tag {
	func foreground(isEnabled: Bool) -> Color {
		if isEnabled {
			switch self {
			case .alcohol: .red
			case .coconut: .mint
			case .dairyFreeOrVegan: .green
			case .glutenFree: .orange
			case .nuts: .brown
			case .sesame: .yellow
			}
		} else {
			.gray
		}
	}

	func background(isEnabled: Bool) -> some ShapeStyle {
		if isEnabled {
			switch self {
			case .alcohol: Color.red.tertiary
			case .coconut: Color.gray.tertiary
			case .dairyFreeOrVegan: Color.green.tertiary
			case .glutenFree: Color.orange.tertiary
			case .nuts: Color.brown.tertiary
			case .sesame: Color.yellow.tertiary
			}
		} else {
			Color.gray.tertiary
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
