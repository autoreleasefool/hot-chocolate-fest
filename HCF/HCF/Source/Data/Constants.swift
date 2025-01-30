import Foundation

enum Constants {
	enum Dates {
		static let startDate = Date(timeIntervalSince1970: 1737187200)
		static let endDate = Date(timeIntervalSince1970: 1739606400)
	}
}

extension URL {
	static let favourites: URL = .documentsDirectory.appendingPathComponent("favourites")
	static let tasted: URL = .documentsDirectory.appendingPathComponent("tasted")
	static let wishlist: URL = .documentsDirectory.appendingPathComponent("wishlist")
}
