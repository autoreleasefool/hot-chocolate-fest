import Flow
import SwiftUI

struct FlavourDetailsView: View {
	@EnvironmentObject private var flavoursRepository: FlavoursRepository

	@State private var viewModel: FlavourDetailsViewModel

	init(flavourId: Flavour.ID) {
		self.viewModel = FlavourDetailsViewModel(flavourId: flavourId)
	}

	var body: some View {
		List {
			Section {
				ForEach(viewModel.description, id: \.self) { description in
					Text(description)
				}
			}

			let tags = viewModel.tags
			if !tags.isEmpty {
				Section {
					HFlow {
						ForEach(tags) { tag in
							Badge(
								text: tag.title,
								foreground: tag.foreground(isEnabled: true),
								background: tag.background(isEnabled: true)
							)
						}
					}
				}
				.listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
				.listRowBackground(Color.clear)
			}
		}
		.task {
			viewModel.setup(repository: flavoursRepository)
			await viewModel.task()
		}
		.navigationTitle(viewModel.flavour?.name ?? "Loading...")
		.toolbar {
			ToolbarItem {
				Button {
					Task {
						await viewModel.handleAction(.didToggleFavourite)
					}
				} label: {
					Image(systemName: "star")
						.symbolVariant(viewModel.isFavourite ? .fill : .none)
				}
			}

			ToolbarItem {
				Button {
					Task {
						await viewModel.handleAction(.didToggleTasted)
					}
				} label: {
					Image(systemName: "cup.and.saucer")
						.symbolVariant(viewModel.isTasted ? .fill : .none)
				}
			}

			ToolbarItem {
				Button {
					Task {
						await viewModel.handleAction(.didToggleWishlist)
					}
				} label: {
					Image(systemName: "heart")
						.symbolVariant(viewModel.isWishlist ? .fill : .none)
				}
			}
		}
	}
}

extension FlavourDetailsView {
	enum Action {
		case didToggleFavourite
		case didToggleTasted
		case didToggleWishlist
	}
}
