import MapKit
import SwiftData
import SwiftUI

struct VendorMapView: View {
	@State private var vendors: [Vendor] = []

	var body: some View {
		content
			.task {
				self.vendors = (try? await VendorRepository.shared.loadVendors()) ?? []
			}
	}

	@ViewBuilder
	private var content: some View {
		if vendors.isEmpty {
			ProgressView()
		} else {
			Map {
				ForEach(vendors) { vendor in
					Marker(vendor.name, coordinate: vendor.location)
				}
			}
		}
	}
}
