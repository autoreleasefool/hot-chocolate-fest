import SwiftData
import SwiftUI

struct VendorDetailsView: View {
	let vendor: Vendor

	var body: some View {
		ScrollView {
			Text(vendor.name)
		}
		.navigationTitle(vendor.name)
	}
}
