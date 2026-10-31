import Foundation

/// The small, Codable value stored in Coordinates.plist.
struct CarCoordinate: Codable, Equatable {
    var latitude: Double
    var longitude: Double

    /// Creates a coordinate; zero/zero represents no parked car in this lab.
    init(latitude: Double = 0, longitude: Double = 0) {
        self.latitude = latitude
        self.longitude = longitude
    }

    var hasLocation: Bool { latitude != 0 || longitude != 0 }
}
