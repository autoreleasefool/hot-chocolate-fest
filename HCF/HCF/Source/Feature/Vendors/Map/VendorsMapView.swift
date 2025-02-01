import MapKit
import SwiftUI

struct VendorsMapView: View {
	let vendors: [VendorsViewModel.VendorListItem]
	@State private var vendor: VendorsViewModel.VendorListItem?

	var body: some View {
		Map(selection: $vendor) {
			ForEach(vendors) { vendor in
				Marker(vendor.name, coordinate: vendor.location.coordinate)
					.tag(vendor)
			}
		}
		.navigationDestination(item: $vendor) {
			VendorDetailsView(vendorId: $0.id)
		}
	}
}
