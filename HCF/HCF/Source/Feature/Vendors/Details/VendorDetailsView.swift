import MapKit
import SwiftUI

struct VendorDetailsView: View {
	@EnvironmentObject private var vendorsRepository: VendorsRepository
	@EnvironmentObject private var flavoursRepository: FlavoursRepository

	@State private var viewModel: VendorDetailsViewModel

	init(vendorId: Vendor.ID) {
		self.viewModel = VendorDetailsViewModel(vendorId: vendorId)
	}

	var body: some View {
		List {
			if let vendor = viewModel.vendor {
				mapSection(vendor)
			}
		}
		.task {
			viewModel.setup(vendorsRepository: vendorsRepository, flavoursRepository: flavoursRepository)
			await viewModel.task()
		}
		.navigationTitle(viewModel.vendor?.name ?? "Loading...")
	}

	@ViewBuilder
	private func mapSection(_ vendor: Vendor) -> some View {
		Section {
			Map(position: .constant(viewModel.mapPosition), interactionModes: []) {
				Marker(vendor.name, coordinate: vendor.location.coordinate)
			}
			.frame(maxWidth: .infinity)
			.frame(height: 125)
			.padding(0)
		}
		.listRowInsets(EdgeInsets())
	}
}
