import Foundation
import CoreLocation
import Observation

@MainActor
@Observable
final class LocationManager: NSObject {
    var coordinate = CarCoordinate()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationError: String?
    private(set) var isSaving = false

    @ObservationIgnored private let locationManager = CLLocationManager()
    @ObservationIgnored private let storageURL: URL
    @ObservationIgnored private var locationSaveCompletion: (() -> Void)?
    @ObservationIgnored private var timeoutTask: Task<Void, Never>?

    /// Configures Core Location and restores the last saved parking location.
    /// Tests can supply their own file so they never alter the user's parking data.
    init(storageURL: URL = URL.documentsDirectory.appendingPathComponent("Coordinates.plist")) {
        self.storageURL = storageURL
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        authorizationStatus = locationManager.authorizationStatus
        loadLocation()
    }

    /// Requests permission when necessary and saves the next valid location fix.
    func saveCurrentLocation(completion: @escaping () -> Void = {}) {
        guard !isSaving else { return }
        locationError = nil
        isSaving = true
        locationSaveCompletion = completion
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            finish(error: "Location access denied. Please enable it in Settings.")
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            finish(error: "Unknown location authorization status.")
        }
    }

    /// Resets both the displayed coordinate and the persisted parking location.
    func clearLocation() {
        locationError = nil
        if saveLocationToPlist(CarCoordinate()) { coordinate = CarCoordinate() }
    }

    /// Atomically writes XML so an interrupted save cannot leave a partial file.
    @discardableResult
    private func saveLocationToPlist(_ value: CarCoordinate) -> Bool {
        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            try encoder.encode(value).write(to: storageURL, options: .atomic)
            return true
        } catch {
            locationError = "Failed to save location: \(error.localizedDescription)"
            return false
        }
    }

    /// Restores coordinates if a plist exists and reports unreadable saved data.
    private func loadLocation() {
        guard FileManager.default.fileExists(atPath: storageURL.path) else { return }
        do {
            coordinate = try PropertyListDecoder().decode(CarCoordinate.self, from: Data(contentsOf: storageURL))
        } catch {
            locationError = "Failed to load saved location: \(error.localizedDescription)"
        }
    }

    /// Starts a bounded location request so the interface cannot spin forever.
    private func startLocationUpdates() {
        guard isSaving else { return }
        locationManager.startUpdatingLocation()
        timeoutTask?.cancel()
        timeoutTask = Task { [weak self] in
            do { try await Task.sleep(for: .seconds(20)) } catch { return }
            self?.finish(error: "Could not get a location. Check Location Services and try again.")
        }
    }

    /// Stops GPS updates and completes each pending request exactly once.
    private func finish(error: String? = nil) {
        locationManager.stopUpdatingLocation()
        timeoutTask?.cancel()
        timeoutTask = nil
        if let error { locationError = error }
        isSaving = false
        let completion = locationSaveCompletion
        locationSaveCompletion = nil
        completion?()
    }
}

// Core Location delivers callbacks on the run loop where its manager was created (main).
extension LocationManager: @preconcurrency CLLocationManagerDelegate {
    /// Resumes a requested save after permission is granted without overwriting a car at launch.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        guard isSaving else { return }
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: startLocationUpdates()
        case .denied, .restricted: finish(error: "Location access denied. Please enable it in Settings.")
        default: break
        }
    }

    /// Persists the latest valid fix, then stops updating to conserve battery.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isSaving, let location = locations.last,
              location.horizontalAccuracy >= 0,
              abs(location.timestamp.timeIntervalSinceNow) < 30 else { return }
        let next = CarCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if saveLocationToPlist(next) { coordinate = next }
        finish()
    }

    /// Reports GPS failures and releases the pending save action.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard isSaving else { return }
        finish(error: "Failed to get location: \(error.localizedDescription)")
    }
}
