import Foundation

struct Region: Identifiable {
	let name: String
	let vendors: [Vendor]

	var id: String { name }
}
