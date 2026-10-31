import SwiftUI

struct AppView: View {
    @State private var locationManager = LocationManager()
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 64)).foregroundStyle(.blue)
                        .accessibilityHidden(true)
                    Text("Find My Car").font(.largeTitle.bold())
                    Text(locationManager.coordinate.hasLocation ? "Location Saved" : "Save where you parked")
                        .font(.subheadline)
                        .foregroundStyle(locationManager.coordinate.hasLocation ? .green : .secondary)
                }
                Spacer()
                Button(action: saveCar) {
                    HStack {
                        if locationManager.isSaving { ProgressView().tint(.white) }
                        Label(locationManager.isSaving ? "Saving Location…" : "Here's My Car", systemImage: "car.fill")
                    }
                    .font(.headline).foregroundStyle(.white).padding()
                    .frame(maxWidth: .infinity).background(.blue, in: RoundedRectangle(cornerRadius: 10))
                }
                .disabled(locationManager.isSaving)
                .accessibilityIdentifier("saveCarButton")
                NavigationLink {
                    MapView(locationManager: locationManager)
                } label: {
                    Label("Where's My Car?", systemImage: "map.fill")
                        .font(.headline).foregroundStyle(.white).padding()
                        .frame(maxWidth: .infinity)
                        .background(locationManager.coordinate.hasLocation ? Color.green : Color.gray,
                                    in: RoundedRectangle(cornerRadius: 10))
                }
                .disabled(!locationManager.coordinate.hasLocation)
                .accessibilityIdentifier("findCarButton")
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
            .alert(locationManager.locationError == nil ? "Location Saved" : "Location Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(locationManager.locationError ?? generateLocationMessage())
            }
        }
    }

    /// Shows success only after persistence succeeds; failures use an error title.
    private func saveCar() {
        locationManager.saveCurrentLocation { showingAlert = true }
    }

    /// Formats the saved GPS coordinates to six decimal places for confirmation.
    private func generateLocationMessage() -> String {
        let lat = String(format: "%.6f", locationManager.coordinate.latitude)
        let lon = String(format: "%.6f", locationManager.coordinate.longitude)
        return "Your car is at:\n(\(lat), \(lon))\n\nTap 'Where's My Car?' to view on the map."
    }
}
