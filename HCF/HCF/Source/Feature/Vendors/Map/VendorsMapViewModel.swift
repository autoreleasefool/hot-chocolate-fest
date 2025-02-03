
import MapKit
import SwiftUI

@MainActor
@Observable
final class VendorsMapViewModel {

    // MARK: Properties
    var selectedVendor: VendorsViewModel.VendorListItem?

    var mapPosition: MapCameraPosition = .region(.init(center: .init(), latitudinalMeters: 200, longitudinalMeters: 200))

    // MARK: Initialization

    // MARK: Public

    func centerMapOnVendors(_ vendors: [VendorsViewModel.VendorListItem]) {
        let locations = vendors.map(\.location)
        let region = MKCoordinateRegion(
            center: locations.center,
            latitudinalMeters: 200,
            longitudinalMeters: 200
        )
        mapPosition = .region(region)
    }
}

extension Array where Element == Vendor.Location {
    var center: CLLocationCoordinate2D {
        let latitudes = map(\.latitude)
        let longitudes = map(\.longitude)
        return CLLocationCoordinate2D(latitude: latitudes.average, longitude: longitudes.average)
    }
}

extension Array where Element == Double {
    var average: Double {
        guard !isEmpty else { return 0 }
        return reduce(0, +) / Double(count)
    }
}
