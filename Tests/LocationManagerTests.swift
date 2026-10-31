import Testing
import Foundation
import CoreLocation
@testable import FindMyCar

@MainActor
struct LocationManagerTests {
    /// Returns an isolated path so parallel tests cannot share parking state.
    private func freshURL() -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).plist")
    }

    /// A new store starts with the no-location value.
    @Test func startsWithZeroCoordinate() {
        let manager = LocationManager(storageURL: freshURL())
        #expect(manager.coordinate == CarCoordinate())
    }

    /// Clearing a location resets both memory and the data read by a new manager.
    @Test func clearLocationResetsCoordinate() throws {
        let url = freshURL()
        defer { try? FileManager.default.removeItem(at: url) }
        let manager = LocationManager(storageURL: url)
        manager.coordinate = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        manager.clearLocation()
        #expect(manager.coordinate == CarCoordinate())
        #expect(LocationManager(storageURL: url).coordinate == CarCoordinate())
    }

    /// Denied access returns an error, completes once, and leaves no spinner.
    @Test func deniedAuthorizationProducesError() {
        let manager = LocationManager(storageURL: freshURL())
        manager.authorizationStatus = .denied
        var completions = 0
        manager.saveCurrentLocation { completions += 1 }
        #expect(manager.locationError != nil)
        #expect(!manager.isSaving)
        #expect(completions == 1)
    }

    /// Previously persisted parking data survives construction of a new manager.
    @Test func loadsSavedCoordinate() throws {
        let url = freshURL()
        defer { try? FileManager.default.removeItem(at: url) }
        let car = CarCoordinate(latitude: 40.444644, longitude: -79.945424)
        try PropertyListEncoder().encode(car).write(to: url)
        #expect(LocationManager(storageURL: url).coordinate == car)
    }

    /// Corrupt saved data produces useful feedback instead of a crash.
    @Test func corruptPlistReportsError() throws {
        let url = freshURL()
        defer { try? FileManager.default.removeItem(at: url) }
        try Data("invalid plist".utf8).write(to: url)
        let manager = LocationManager(storageURL: url)
        #expect(manager.coordinate == CarCoordinate())
        #expect(manager.locationError != nil)
    }
}
