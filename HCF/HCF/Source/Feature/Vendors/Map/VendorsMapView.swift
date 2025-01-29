import MapKit
import SwiftUI

struct VendorsMapView: View {
	let vendors: [Vendor]
	@State private var vendor: Vendor?

	var body: some View {
		Map(selection: $vendor) {
			ForEach(vendors) { vendor in
				Marker(vendor.name, coordinate: vendor.location.coordinate)
					.tag(vendor)
			}
		}
		.navigationDestination(item: $vendor) {
			VendorDetailsView(vendor: $0)
		}
	}
}
