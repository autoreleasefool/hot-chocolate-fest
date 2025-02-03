import MapKit
import SwiftUI

struct VendorsMapView: View {
	let vendors: [VendorsViewModel.VendorListItem]

	@State private var viewModel = VendorsMapViewModel()

	var body: some View {
		Map(position: $viewModel.mapPosition, selection: $viewModel.selectedVendor) {
			ForEach(vendors) { vendor in
				Marker(vendor.name, coordinate: vendor.location.coordinate)
					.tag(vendor)
			}
		}
		.task(id: vendors) {
			viewModel.centerMapOnVendors(vendors)
		}
		.navigationDestination(item: $viewModel.selectedVendor) {
			VendorDetailsView(vendorId: $0.id)
		}
	}
}
