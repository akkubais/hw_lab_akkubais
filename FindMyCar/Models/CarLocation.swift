import Foundation
import CoreLocation

/// An identifiable annotation for the parked car.
struct CarLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
}
