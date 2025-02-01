import SwiftUI

struct VendorsListView: View {
	let vendors: [VendorsViewModel.VendorListItem]

	var body: some View {
		List {
			ForEach(vendors) { vendor in
				NavigationLink(value: vendor.id) {
					Text(vendor.name)
				}
			}
		}
	}
}
