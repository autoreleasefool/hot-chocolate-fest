import SwiftData
import SwiftUI

struct VendorsListView: View {
	let vendors: [Vendor]

	var body: some View {
		List {
			ForEach(vendors) { vendor in
				NavigationLink(value: vendor) {
					Text(vendor.name)
				}
			}
		}
	}
}
