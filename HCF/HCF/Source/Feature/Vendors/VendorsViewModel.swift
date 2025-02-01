import SwiftUI

@MainActor
@Observable
final class VendorsViewModel {

    // MARK: Properties

    private(set) var query: String = ""
	private(set) var vendors: [VendorListItem] = []
    private(set) var displayMode: DisplayMode = .map

    // Dependencies
    private var repository: VendorsRepository?

	// MARK: Initialization

	init() {}

    // MARK: Public

    func setup(repository: VendorsRepository) {
        self.repository = repository
    }

    func task() async {
        await refreshVendors()
    }

    func handleAction(_ action: VendorsView.Action) async {
        switch action {
            case let .didChangeQuery(query): await changeQuery(query)
            case .didToggleDisplayMode: await toggleDisplayMode()
        }
    }

    // MARK: Private

    private func refreshVendors() async {
        do {
            let vendors = try await repository?.fetch() ?? []
            self.vendors = vendors
                .filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
                .map {
                    VendorListItem(
                        id: $0.id,
                        name: $0.name,
                        location: $0.location
                    )
                }
        } catch {
            print(error)
        }
    }

    private func changeQuery(_ query: String) async {
        self.query = query
        await refreshVendors()
    }

    private func toggleDisplayMode() async {
        self.displayMode.toggle()
    }
}

extension VendorsViewModel {
	enum DisplayMode {
		case map
		case list

		mutating func toggle() {
			self = switch self {
			case .map: .list
			case .list: .map
			}
		}
	}
}

extension VendorsViewModel {
    struct VendorListItem: Identifiable, Hashable {
        let id: Vendor.ID
        let name: String
        let location: Vendor.Location
    }
}
