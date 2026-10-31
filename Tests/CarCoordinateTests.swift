import Testing
import Foundation
@testable import FindMyCar

struct CarCoordinateTests {
    /// Confirms the lab's no-location sentinel uses zero for both values.
    @Test func defaultInitializerIsZero() {
        let coordinate = CarCoordinate()
        #expect(coordinate.latitude == 0)
        #expect(coordinate.longitude == 0)
    }

    /// Confirms an explicitly supplied GPS position is retained unchanged.
    @Test func customInitializerStoresValues() {
        let coordinate = CarCoordinate(latitude: 40.7128, longitude: -74.0060)
        #expect(coordinate.latitude == 40.7128)
        #expect(coordinate.longitude == -74.0060)
    }

    /// Verifies equality compares latitude and longitude, rather than identity.
    @Test func equalityWorks() {
        let a = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        #expect(a == CarCoordinate(latitude: 40.4446, longitude: -79.9454))
        #expect(a != CarCoordinate())
    }

    /// Checks that a plist round trip preserves the saved coordinate exactly.
    @Test func encodesAndDecodesRoundTrip() throws {
        let original = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        let data = try PropertyListEncoder().encode(original)
        #expect(try PropertyListDecoder().decode(CarCoordinate.self, from: data) == original)
    }
}
