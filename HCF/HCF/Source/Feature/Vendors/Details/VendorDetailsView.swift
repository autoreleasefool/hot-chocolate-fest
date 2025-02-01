import SwiftUI

struct VendorDetailsView: View {
	let vendorId: Vendor.ID

	var body: some View {
		ScrollView {
			Text("Vendor")
		}
		.navigationTitle("Vendor")
	}
}
