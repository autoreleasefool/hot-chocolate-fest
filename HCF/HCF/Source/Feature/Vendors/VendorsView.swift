import SwiftUI

struct VendorsView: View {
	@EnvironmentObject private var vendorsRepository: VendorsRepository

	@State private var viewModel = VendorsViewModel()
	@State private var query: String = ""

	var body: some View {
		content
			.task {
				viewModel.setup(repository: vendorsRepository)
				await viewModel.task()
			}
			.task(id: query) {
				do {
					try await Task.sleep(for: .milliseconds(300))
					await viewModel.handleAction(.didChangeQuery(query))
				} catch {}
			}
			.navigationTitle("Locations")
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $query)
			.navigationDestination(for: Vendor.ID.self) { vendorId in
				VendorDetailsView(vendorId: vendorId)
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						Task { await viewModel.handleAction(.didToggleDisplayMode) }
					} label: {
						Image(systemName: viewModel.displayMode == .map ? "list.bullet" : "map")
					}
				}
			}
	}

	@ViewBuilder
	private var content: some View {
		switch viewModel.displayMode {
		case .map:
			VendorsMapView(vendors: viewModel.vendors)
		case .list:
			VendorsListView(vendors: viewModel.vendors)
		}
	}
}

extension VendorsView {
	enum Action {
		case didChangeQuery(String)
		case didToggleDisplayMode
	}
}
